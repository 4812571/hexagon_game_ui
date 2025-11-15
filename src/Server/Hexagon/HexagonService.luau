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
local peek = Fusion.peek
local Children = Fusion.Children

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

local COINS_PER_TILE = 1

local function HexagonService(scope: Fusion.Scope<typeof(Fusion)>, services: Services): HexagonService
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
        local skins = renderer.GetSkins()

        local owned = {}

        for axial, owner in world.GetOwnedTiles() do
            if not owned[owner.RenderId] then
                owned[owner.RenderId] = {}
            end

            table.insert(owned[owner.RenderId], axial)
        end

        local selected = {}


        for axial, owner in world.GetSelectedTiles() do
            if not selected[owner.RenderId] then
                selected[owner.RenderId] = {}
            end

            table.insert(selected[owner.RenderId], axial)
        end

        local data: HexagonData = {
            Skins = skins,
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
        renderer.UnregisterSkin(player.RenderId)
        activePlayers[player.Player] = nil

        player.Player.Hexagons.IsInGame:set(false)
        player.Player.Hexagons.Tiles:set(0)
        NetworkServer.Hexagon.TilesCleared.Fire(player.Player.Player)

        playerRemoved:Fire(player)
    end

    local function JoinPlayer(player: ServerPlayer, character: Model): HexagonPlayer
        local renderId = renderer.RegisterSkin(colors.Next(), peek(player.Skins.SkinImage))
        local hexagonPlayer = HexagonPlayer(player, character, renderId)

        local spawnPoint = world.FindBestSpawn()
        world.ClaimRadius(hexagonPlayer, spawnPoint, 3)

        local worldPosition = HexagonUtil.AxialToWorld(spawnPoint) * HexagonConfig.HexagonSize
        character:PivotTo(CFrame.new(worldPosition + Vector3.yAxis * 5))

        player.Hexagons.IsInGame:set(true)
        player.Hexagons.Tiles:set(world.GetCount(hexagonPlayer))

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
            local previousTiles = peek(player.Player.Hexagons.Tiles)
            local currentTiles = world.GetCount(player)

            local tileDelta = currentTiles - previousTiles

            if tileDelta == 0 then
                continue
            end

            player.Player.Hexagons.Tiles:set(currentTiles)
            NetworkServer.Hexagon.TileChanged.Fire(player.Player.Player, tileDelta)

            if tileDelta > 0 then
                local coinReward = math.floor(tileDelta * COINS_PER_TILE)
                player.Player.Coins.AwardCoins(coinReward)

                NetworkServer.Hexagon.CoinReward.Fire(player.Player.Player, coinReward)
            end
        end

        UpdateCrowned()
    end

    local function Init()
        Connect(scope, world.OwnerChanged, function(axial: Axial, owner: HexagonPlayer?)
            renderer.SetTile(axial, if owner then owner.RenderId else nil)
        end)

        Connect(scope, world.SelectionChanged, function(axial: Axial, selector: HexagonPlayer?)
            renderer.SetSelection(axial, if selector then selector.RenderId else nil)
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
            local scope = scope:innerScope()

            local leaderstats = scope:New "Folder" {
                Name = "leaderstats",

                [Children] = {
                    scope:New "IntValue" {
                        Name = "Tiles",
                        Value = serverPlayer.Hexagons.Tiles,
                    },

                    scope:New "IntValue" {
                        Name = "Wins",
                        Value = 0,
                    },
                }
            }

            scope:Observer(serverPlayer.Hexagons.Tiles):onBind(function()
                NetworkServer.Hexagon.IsInGameChanged.Fire(serverPlayer.Player, peek(serverPlayer.Hexagons.IsInGame))
            end)

            scope:Observer(serverPlayer.Skins.SkinImage):onBind(function()
                local hexagonPlayer = GetPlayer(serverPlayer)

                if not hexagonPlayer then
                    return
                end

                renderer.SetImage(hexagonPlayer.RenderId, peek(serverPlayer.Skins.SkinImage))
            end)

            leaderstats.Parent = serverPlayer.Player

            return function()
                scope:doCleanup()
            end
        end))

        Connect(scope, renderer.SkinRegistered, function(id: number, color: Color3, imageId: string?)
            PlayerService.FireAll(NetworkServer.Hexagon.SkinRegistered, id, color, imageId)
        end)

        Connect(scope, renderer.SkinUnregistered, function(id: number)
            PlayerService.FireAll(NetworkServer.Hexagon.SkinUnregistered, id)
        end)

        Connect(scope, renderer.SkinImageChanged, function(id: number, imageId: string?)
            PlayerService.FireAll(NetworkServer.Hexagon.SkinImageChanged, id, imageId)
        end)

        Connect(scope, renderer.TilesChanged, function(id: number?, axials: {Axial})
            PlayerService.FireAll(NetworkServer.Hexagon.HexagonsFilled, id, axials)
        end)

        Connect(scope, renderer.SelectionsChanged, function(id: number?, axials: {Axial})
            PlayerService.FireAll(NetworkServer.Hexagon.HexagonsSelected, id, axials)
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
