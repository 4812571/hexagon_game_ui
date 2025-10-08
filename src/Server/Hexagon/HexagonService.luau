--!strict

local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Server = ServerScriptService.Server

type Set<T> = { [T]: true }

local Fusion = require(Packages.Fusion)
type Scope = Fusion.Scope<unknown>

local Observe = require(Packages.Observe)

local Count = require(Common.Util.Count)
local Sequence = require(Common.Util.Sequence)
local Timer = require(Common.Util.Timer)

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
type HexagonPlayer = HexagonPlayer.HexagonPlayer

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
    FloodTiles: (player: HexagonPlayer, tiles: {Axial}) -> (),
    FinishSelection: (player: HexagonPlayer) -> SelectionResult?,
}

local function HexagonService(scope: Scope, services: Services): HexagonService
    local PlayerService = services.PlayerService

    local world = HexagonInteractionWorld(scope, HexagonConfig.WorldRadius)
    local renderer = HexagonRenderer(scope)

    local colors = Sequence(COLORS)

    local activePlayers: {[ServerPlayer]: HexagonPlayer} = {}
    
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

    local function JoinPlayer(player: ServerPlayer, character: Model): HexagonPlayer
        local hexagonPlayer = HexagonPlayer(player, character, colors.Next())

        local spawnPoint = world.FindBestSpawn()
        world.ClaimRadius(hexagonPlayer, spawnPoint, 3)

        local worldPosition = HexagonUtil.AxialToWorld(spawnPoint) * HexagonConfig.HexagonSize
        character:PivotTo(CFrame.new(worldPosition + Vector3.yAxis * 5))

        activePlayers[player] = hexagonPlayer
        return hexagonPlayer
    end

    local function RemovePlayer(player: HexagonPlayer)
        world.RemoveFromGame(player)
        activePlayers[player.Player] = nil

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
            local humanoid = otherPlayer.Character:FindFirstChildOfClass("Humanoid")

            if humanoid then
                humanoid.Health = 0
            end

            RemovePlayer(otherPlayer)
        end
    end

    local function FinishSelection(player: HexagonPlayer): SelectionResult?
        local selectionResult = world.FinishSelection(player)

        if not selectionResult then
            return nil
        end

        NetworkServer.Hexagon.ClaimEffect.Fire(player.Player.Player, Count(selectionResult.OuterClaimed), Count(selectionResult.InnerClaimed))

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
            local humanoid = otherPlayer.Character:FindFirstChildOfClass("Humanoid")

            if humanoid then
                humanoid.Health = 0
            end

            RemovePlayer(otherPlayer)
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
        NetworkServer.Hexagon.WinnerSeconds.FireAll(RobloxPlayer(winnerCandidate), winnerSeconds)

        if winnerSeconds <= 0 then
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

        NetworkServer.Hexagon.PlayerCrowned.FireAll(RobloxPlayer(crownPlayer))

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

            NetworkServer.Hexagon.ClaimEffect.Fire(player.Player.Player, Count(claimed.OuterClaimed), Count(claimed.InnerClaimed))

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
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")

            if humanoid then
                humanoid.Health = 0
            end

            RemovePlayer(player)
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
        table.insert(scope, world.OwnerChanged:Connect(function(axial: Axial, owner: HexagonPlayer?)
            renderer.SetTileColor(axial, Color(owner))
        end))

        table.insert(scope, world.SelectionChanged:Connect(function(axial: Axial, selector: HexagonPlayer?)
            renderer.SetSelectionColor(axial, Color(selector))
        end))
    end

    local function Start()
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

            return Observe.Character(serverPlayer.Player, function(character: Model?)
                if not character then
                    return
                end

                local hexagonPlayer = JoinPlayer(serverPlayer, character)

                return function()
                    RemovePlayer(hexagonPlayer)
                end
            end)
        end))
        
        table.insert(scope, renderer.TilesChanged:Connect(function(color: Color3?, axials: {Axial})
            for _, serverPlayer in PlayerService.GetAll() do
                NetworkServer.Hexagon.HexagonsColored.Fire(serverPlayer.Player, color, axials)
            end
        end))

        table.insert(scope, renderer.SelectionsChanged:Connect(function(color: Color3?, axials: {Axial})
            for _, serverPlayer in PlayerService.GetAll() do
                NetworkServer.Hexagon.HexagonsSelected.Fire(serverPlayer.Player, color, axials)
            end
        end))

        table.insert(scope, RunService.Heartbeat:Connect(Update))
    end

    local self = {
        InitialData = InitialData,
        GetPlayer = GetPlayer,
        FloodTiles = FloodTiles,
        Init = Init,
        Start = Start,
        FinishSelection = FinishSelection,
    }

    return self
end

return HexagonService