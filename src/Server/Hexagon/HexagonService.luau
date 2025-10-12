--!strict
--!native

local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Server = ServerScriptService.Server

type Set<T> = { [T]: true }

local Fusion = require(Packages.Fusion)
type Scope = Fusion.Scope<unknown>

local Count = require(Common.Util.Count)
local Sequence = require(Common.Util.Sequence)
local Timer = require(Common.Util.Timer)
local Signal = require(Common.Signal)
local Connect = require(Common.Connect)

local HexagonConfig = require(Common.Hexagon.HexagonConfig)

local HexagonUtil = require(Common.Hexagon.HexagonUtil)
type Axial = HexagonUtil.Axial

local HexagonData = require(Common.Hexagon.HexagonData)
type HexagonData = HexagonData.HexagonData

local NetworkServer = require(ServerScriptService.NetworkServer)

local PlayerService = require(Server.Player.PlayerService)
type PlayerService = PlayerService.PlayerService

local ServerPlayer = require(Server.Player.ServerPlayer)
type ServerPlayer = ServerPlayer.ServerPlayer

local HexagonPlayer = require(Server.Hexagon.HexagonPlayer)
export type HexagonPlayer = HexagonPlayer.HexagonPlayer

local HexagonInteractionWorld = require(Server.Hexagon.HexagonInteractionWorld)
local HexagonRenderer = require(Server.Hexagon.HexagonRenderer)

local COLORS = {
    Color3.fromRGB(255, 0, 0),
    Color3.fromRGB(0, 255, 0),
    Color3.fromRGB(0, 0, 255),
    Color3.fromRGB(255, 255, 0),
    Color3.fromRGB(0, 255, 255),
    Color3.fromRGB(255, 0, 255),
    Color3.fromRGB(255, 165, 0),
    Color3.fromRGB(128, 0, 128),
}

local WINNER_TILES = 10_000
local WIN_SECONDS = 10

type PartitionedTouches = {
    SelfTerritory: {[HexagonPlayer]: Axial},
    OtherTerritory: {[HexagonPlayer]: Axial},
    OtherSelection: {[HexagonPlayer]: HexagonPlayer},
}

type TileSet = {[string]: Axial}

type SelectionResult = {
    OuterClaimed: TileSet,
    InnerClaimed: TileSet,
}

local function Color(player: HexagonPlayer?): Color3?
    if not player then
        return nil
    end

    return player.Color
end

type Services = {
    PlayerService: PlayerService,
}

export type HexagonService = {
    InitialData: () -> HexagonData,

    Init: () -> (),
    Start: () -> (),

    GetPlayer: (player: ServerPlayer) -> HexagonPlayer?,
    JoinPlayer: (player: ServerPlayer, character: Model) -> HexagonPlayer,
    RemovePlayer: (player: HexagonPlayer) -> (),
    FloodTiles: (player: HexagonPlayer, tiles: {Axial}) -> (),
    FinishSelection: (player: HexagonPlayer) -> SelectionResult?,

    PlayerRemoved: Signal.Signal<HexagonPlayer>,
    PlayerKilled: Signal.Signal<HexagonPlayer, HexagonPlayer>,
    PlayerWon: Signal.Signal<HexagonPlayer>,
    Claimed: Signal.Signal<HexagonPlayer, number, number>,
}

local function HexagonService(scope: Scope, services: Services): HexagonService
    local PlayerService = services.PlayerService

    local world = HexagonInteractionWorld(scope, HexagonConfig.WorldRadius)
    local renderer = HexagonRenderer(scope)

    local colors = Sequence(COLORS)

    local activePlayers: {[ServerPlayer]: HexagonPlayer} = {}

    local playerKilled: Signal.Signal<HexagonPlayer, HexagonPlayer> = Signal(scope)

    Connect(scope, playerKilled, function(killer: HexagonPlayer, victim: HexagonPlayer)
        PlayerService.FireAll(NetworkServer.Hexagon.PlayerKilled, killer.Player.Player, victim.Player.Player)
    end)

    local playerWon: Signal.Signal<HexagonPlayer> = Signal(scope)

    Connect(scope, playerWon, function(winner: HexagonPlayer)
        PlayerService.FireAll(NetworkServer.Hexagon.PlayerWon, winner.Player.Player)
    end)

    local claimedSignal: Signal.Signal<HexagonPlayer, number, number> = Signal(scope)

    Connect(scope, claimedSignal, function(player: HexagonPlayer, outer: number, inner: number)
        NetworkServer.Hexagon.Claimed.Fire(player.Player.Player, outer, inner)
    end)

    local playerRemoved: Signal.Signal<HexagonPlayer> = Signal(scope)

    Connect(scope, playerRemoved, function(player: HexagonPlayer)
        NetworkServer.Respawn.GameOver.Fire(player.Player.Player)
    end)

    local function InitialData(): HexagonData
        local owned = {}

        for axial, owner in world.GetOwnedTiles() do
            owned[axial] = owner.Color
        end

        local selected = {}

        for axial, selector in world.GetSelectedTiles() do
            selected[axial] = selector.Color
        end

        local data: HexagonData = {
            Owned = owned,
            Selected = selected,
        }

        return data
    end

    local function GetPlayer(player: ServerPlayer): HexagonPlayer?
        return activePlayers[player]
    end

    local function RemovePlayer(player: HexagonPlayer)
        world.RemoveFromGame(player)
        activePlayers[player.Player] = nil

        playerRemoved:Fire(player)

        local leaderstats = player.Player.Player:FindFirstChild("leaderstats")

        if not leaderstats then
            return
        end

        local tiles = leaderstats:FindFirstChild("Tiles") :: IntValue?

        if not tiles then
            return
        end

        tiles.Value = 0
    end

    local function JoinPlayer(player: ServerPlayer, character: Model): HexagonPlayer
        local hexagonPlayer = HexagonPlayer(player, character, colors.Next())

        local spawnPoint = world.FindBestSpawn()
        world.ClaimRadius(hexagonPlayer, spawnPoint, 3)

        local worldPosition = HexagonUtil.AxialToWorld(spawnPoint) * HexagonConfig.HexagonSize
        character:PivotTo(CFrame.new(worldPosition + Vector3.yAxis * 5))

        activePlayers[player] = hexagonPlayer
        return hexagonPlayer
    end

    local function PlayerPositions(): {[HexagonPlayer]: Axial}
        local positions: {[HexagonPlayer]: Axial} = {}

        for _, player in activePlayers do
            local worldPosition = player.Character:GetPivot().Position
            local hexPosition = worldPosition / HexagonConfig.HexagonSize
            local axial = HexagonUtil.WorldToNearestAxial(hexPosition)
            positions[player] = axial
        end

        return positions
    end

    local function PartitionTouches(playerPositions: {[HexagonPlayer]: Axial}): PartitionedTouches
        local selfTerritoryTouch: {[HexagonPlayer]: Axial} = {}
        local otherTerritoryTouch: {[HexagonPlayer]: Axial} = {}
        local otherSelectionTouch: {[HexagonPlayer]: HexagonPlayer} = {}

        for player, pos in playerPositions do
            local selector = world.GetSelector(pos)
            local owner = world.GetOwner(pos)

            if owner == player then
                selfTerritoryTouch[player] = pos
            else
                otherTerritoryTouch[player] = pos
            end

            if selector and selector ~= player then
                otherSelectionTouch[player] = selector
            end
        end

        local partitioned: PartitionedTouches = {
            SelfTerritory = selfTerritoryTouch,
            OtherTerritory = otherTerritoryTouch,
            OtherSelection = otherSelectionTouch,
        }

        return partitioned
    end

    local function KillPlayer(killer: HexagonPlayer, victim: HexagonPlayer)
        playerKilled:Fire(killer, victim)

        local humanoid = victim.Character:FindFirstChildOfClass("Humanoid")

        if humanoid then
            humanoid.Health = 0
        end

        RemovePlayer(victim)
    end

    local function FloodTiles(player: HexagonPlayer, tiles: {Axial})
        local playerPositions = PlayerPositions()

        local tileSet: TileSet = {}

        for _, tile in tiles do
            tileSet[HexagonUtil.Key(tile)] = tile
        end

        local kills = {}

        for otherPlayer, pos in playerPositions do
            if otherPlayer == player then
                continue
            end

            if tileSet[HexagonUtil.Key(pos)] then
                kills[otherPlayer] = true
            end
        end

        world.ClaimTiles(player, tileSet)

        for otherPlayer, _ in kills do
            KillPlayer(player, otherPlayer)
        end
    end

    local function FinishSelection(player: HexagonPlayer): SelectionResult?
        local selectionResult = world.FinishSelection(player)

        if not selectionResult then
            return nil
        end

        claimedSignal:Fire(player, Count(selectionResult.OuterClaimed), Count(selectionResult.InnerClaimed))

        local playerPositions = PlayerPositions()

        local kills = {}

        for otherPlayer, pos in playerPositions do
            if otherPlayer == player then
                continue
            end

            if selectionResult.InnerClaimed[HexagonUtil.Key(pos)] then
                kills[otherPlayer] = true
            end
        end

        for otherPlayer, _ in kills do
            KillPlayer(player, otherPlayer)
        end

        return selectionResult
    end

    local winnerCandidate: HexagonPlayer? = nil
    local winnerSeconds = WIN_SECONDS

    local function RobloxPlayer(player: HexagonPlayer?): Player?
        if not player then
            return nil
        end

        return player.Player.Player
    end

    table.insert(scope, Timer(1, function()
        PlayerService.FireAll(NetworkServer.Hexagon.WinnerSeconds, RobloxPlayer(winnerCandidate), winnerSeconds)

        if winnerSeconds <= 0 then
            playerWon:Fire(winnerCandidate :: HexagonPlayer)

            for _, player in activePlayers do
                RemovePlayer(player)

                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")

                if humanoid then
                    humanoid.Health = 0
                end
            end

            if not winnerCandidate then
                error("No winner candidate on win")
            end

            -- this is a crime against type theory
            ((winnerCandidate.Player.Player:FindFirstChild("leaderstats") :: IntValue):FindFirstChild("Wins") :: IntValue).Value += 1
        end

        if winnerCandidate then
            winnerSeconds -= 1
        end
    end))

    local function UpdateCrowned()
        local crownPlayer = nil
        local maxTiles = 0

        for _, player in activePlayers do
            local count = world.GetCount(player)

            if count > maxTiles then
                maxTiles = count
                crownPlayer = player
            end
        end

        PlayerService.FireAll(NetworkServer.Hexagon.PlayerCrowned, RobloxPlayer(crownPlayer))

        if maxTiles < WINNER_TILES then
            winnerCandidate = nil
            winnerSeconds = WIN_SECONDS
            return
        end

        if crownPlayer ~= winnerCandidate then
            winnerCandidate = crownPlayer
            winnerSeconds = WIN_SECONDS
            return
        end
    end

    local function Update()
        local playerPositions = PlayerPositions()
        local touches = PartitionTouches(playerPositions)

        local kills = {}

        for _, selector in touches.OtherSelection do
            kills[selector] = true
        end

        for player, axial in touches.OtherTerritory do
            world.SelectTile(player, axial)
        end

        for player, _ in touches.SelfTerritory do
            local claimed = world.FinishSelection(player)

            if not claimed then
                continue
            end

            claimedSignal:Fire(player, Count(claimed.OuterClaimed), Count(claimed.InnerClaimed))

            for otherPlayer, position in playerPositions do
                if otherPlayer == player then
                    continue
                end

                if claimed.InnerClaimed[HexagonUtil.Key(position)] then
                    kills[otherPlayer] = true
                end
            end
        end

        for player, _ in kills do
            KillPlayer(player, player)
        end

        for _, player in activePlayers do
            local count = world.GetCount(player)

            local leaderstats = player.Player.Player:FindFirstChild("leaderstats")

            if not leaderstats then
                continue
            end

            local tiles = leaderstats:FindFirstChild("Tiles") :: IntValue?

            if not tiles then
                continue
            end

            tiles.Value = count
        end

        UpdateCrowned()
    end

    local function Init()
        Connect(scope, world.OwnerChanged, function(axial: Axial, owner: HexagonPlayer?)
            renderer.SetTileColor(axial, Color(owner))
        end)

        Connect(scope, world.SelectionChanged, function(axial: Axial, selector: HexagonPlayer?)
            renderer.SetSelectionColor(axial, Color(selector))
        end)
    end

    local function OnJoin(player: Player)
        local character = player.Character

        if not character then
            return
        end

        JoinPlayer(PlayerService.Expect(player), character)
    end

    local function Start()
        NetworkServer.Hexagon.JoinGame.On(OnJoin)

        table.insert(scope, PlayerService.ObservePlayers(function(serverPlayer: ServerPlayer)
            local leaderstats = Instance.new("Folder")
            leaderstats.Name = "leaderstats"

            local tiles = Instance.new("IntValue")
            tiles.Name = "Tiles"
            tiles.Value = 0

            local wins = Instance.new("IntValue")
            wins.Name = "Wins"
            wins.Value = 0
            
            tiles.Parent = leaderstats
            wins.Parent = leaderstats
            leaderstats.Parent = serverPlayer.Player

            return nil
        end))

        Connect(scope, renderer.TilesChanged, function(color: Color3?, axials: {Axial})
            PlayerService.FireAll(NetworkServer.Hexagon.HexagonsColored, color, axials)
        end)

        Connect(scope, renderer.SelectionsChanged, function(color: Color3?, axials: {Axial})
            PlayerService.FireAll(NetworkServer.Hexagon.HexagonsSelected, color, axials)
        end)

        table.insert(scope, RunService.Heartbeat:Connect(Update))
    end

    local self = {
        InitialData = InitialData,
        JoinPlayer = JoinPlayer,
        RemovePlayer = RemovePlayer,
        GetPlayer = GetPlayer,
        FloodTiles = FloodTiles,
        Init = Init,
        Start = Start,
        FinishSelection = FinishSelection,

        PlayerRemoved = playerRemoved,
        PlayerKilled = playerKilled,
        PlayerWon = playerWon,
        Claimed = claimedSignal,
    }

    return self
end

return HexagonService
