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

local Sequence = require(Common.Util.Sequence)

local HexagonConfig = require(Common.Hexagon.HexagonConfig)

local HexagonUtil = require(Common.Hexagon.HexagonUtil)
type Axial = HexagonUtil.Axial

local HexagonInitialData = require(Common.Hexagon.HexagonInitialData)
type HexagonInitialData = HexagonInitialData.HexagonInitialData

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

type PartitionedTouches = {
    SelfTerritory: {[HexagonPlayer]: Axial},
    OtherTerritory: {[HexagonPlayer]: Axial},
    OtherSelection: {[HexagonPlayer]: HexagonPlayer},
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
    InitialData: () -> HexagonInitialData,

    Init: () -> (),
    Start: () -> (),
}

local function HexagonService(scope: Scope, services: Services): HexagonService
    local PlayerService = services.PlayerService

    local world = HexagonInteractionWorld(scope, HexagonConfig.WorldRadius)
    local renderer = HexagonRenderer(scope)

    local colors = Sequence(COLORS)

    local activePlayers: Set<HexagonPlayer> = {}
    
    local function InitialData(): HexagonInitialData
        local owned = {}

        for axial, owner in world.GetOwnedTiles() do
            owned[axial] = owner.Color
        end

        local selected = {}

        for axial, selector in world.GetSelectedTiles() do
            selected[axial] = selector.Color
        end

        local data: HexagonInitialData = {
            Owned = owned,
            Selected = selected,
        }

        return data
    end

    local function JoinPlayer(player: ServerPlayer, character: Model): HexagonPlayer
        local hexagonPlayer = HexagonPlayer(player, character, colors.Next())

        local spawnPoint = world.FindBestSpawn()
        world.ClaimRadius(hexagonPlayer, spawnPoint, 3)

        local worldPosition = HexagonUtil.AxialToWorld(spawnPoint) * HexagonConfig.HexagonSize
        character:PivotTo(CFrame.new(worldPosition + Vector3.yAxis * 5))

        activePlayers[hexagonPlayer] = true
        return hexagonPlayer
    end

    local function RemovePlayer(player: HexagonPlayer)
        world.RemoveFromGame(player)
        activePlayers[player] = nil
    end

    local function PlayerPositions(): {[HexagonPlayer]: Axial}
        local positions: {[HexagonPlayer]: Axial} = {}

        for player, _ in activePlayers do
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
            local innerClaimed = world.FinishSelection(player)

            if not innerClaimed then
                continue
            end

            for otherPlayer, position in playerPositions do
                if otherPlayer == player then
                    continue
                end

                if innerClaimed[HexagonUtil.Key(position)] then
                    kills[otherPlayer] = true
                end
            end
        end

        for player, _ in kills do
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")

            if humanoid then
                humanoid.Health = 0
            end

            world.RemoveFromGame(player)
            activePlayers[player] = nil
        end
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
        
        Init = Init,
        Start = Start,
    }

    return self
end

return HexagonService