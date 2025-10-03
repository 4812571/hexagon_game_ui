--!strict
--!optimize 2
--!native

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Server = ServerScriptService.Server

local Fusion = require(Packages.Fusion)
type Scope = Fusion.Scope<unknown>

local HexagonUtil = require(Common.Hexagon.HexagonUtil)
type Axial = HexagonUtil.Axial

local Queue = require(Common.Util.Queue)
type Queue<T> = Queue.Queue<T>

local Signal = require(Common.Signal)
type Signal<T...> = Signal.Signal<T...>

local ServerPlayer = require(Server.Player.ServerPlayer)
type ServerPlayer = ServerPlayer.ServerPlayer

type Set<T> = {[T]: true}

export type HexagonPlayer = {
    Player: ServerPlayer,
    Character: Model,
    Color: Color3,
}

type TileSet = {[string]: Axial}

export type HexagonInteractionWorld = {
    GetSelector: (axial: Axial) -> HexagonPlayer?,
    GetOwner: (axial: Axial) -> HexagonPlayer?,

    GetOwnedTiles: () -> {[Axial]: HexagonPlayer},
    GetSelectedTiles: () -> {[Axial]: HexagonPlayer},

    FindBestSpawn: () -> Axial,

    ClaimTiles: (player: HexagonPlayer, tiles: TileSet) -> (),
    ClaimRadius: (player: HexagonPlayer, center: Axial, claimRadius: number) -> (),

    SelectTile: (player: HexagonPlayer, axial: Axial) -> (),
    FinishSelection: (player: HexagonPlayer) -> TileSet?,
    RemoveFromGame: (player: HexagonPlayer) -> (),

    SelectionChanged: Signal<Axial, HexagonPlayer?>,
    OwnerChanged: Signal<Axial, HexagonPlayer?>,
}

local function HexEdges(radius: number): {[string]: Axial}
    local outer = HexagonUtil.Hexagon(radius)
    local inner = HexagonUtil.Hexagon(radius - 1)

    local innerLookup = {}

    for _, axial in inner do
        innerLookup[HexagonUtil.Key(axial)] = true
    end

    local edges = {}

    for _, axial in outer do
        local key = HexagonUtil.Key(axial)

        if innerLookup[key] then
            continue
        end

        edges[key] = axial
    end

    return edges
end

local function Copy<K, V>(original: {[K]: V}): {[K]: V}
    local copy: {[K]: V} = {}

    for k, v in original do
        copy[k] = v
    end

    return copy
end

local function HexagonInteractionWorld(scope: Scope, radius: number): HexagonInteractionWorld
    local border = HexEdges(radius)

    local playerTileSelection: {[HexagonPlayer]: TileSet} = {}
    local playerTileOwnership: {[HexagonPlayer]: TileSet} = {}

    local tileSelection: {[string]: HexagonPlayer?} = {}
    local tileOwnership: {[string]: HexagonPlayer?} = {}

    local function GetSelector(axial: Axial): HexagonPlayer?
        return tileSelection[HexagonUtil.Key(axial)]
    end

    local function GetOwner(axial: Axial): HexagonPlayer?
        return tileOwnership[HexagonUtil.Key(axial)]
    end

    local function GetOwnedTiles(): {[Axial]: HexagonPlayer}
        local owned: {[Axial]: HexagonPlayer} = {}

        for player, tiles in playerTileOwnership do
            for _, axial in tiles do
                owned[axial] = player
            end
        end

        return owned
    end

    local function GetSelectedTiles(): {[Axial]: HexagonPlayer}
        local selected: {[Axial]: HexagonPlayer} = {}

        for player, tiles in playerTileSelection do
            for _, axial in tiles do
                selected[axial] = player
            end
        end

        return selected
    end

    local neighborLookup = {}

    for _, axial in HexagonUtil.Hexagon(radius) do
        local neighbors = {}

        for _, neighbor in HexagonUtil.Neighbors(axial) do
            if not HexagonUtil.IsInBounds(neighbor, radius) then
                continue
            end

            neighbors[HexagonUtil.Key(neighbor)] = neighbor
        end

        neighborLookup[HexagonUtil.Key(axial)] = neighbors
    end

    local allTiles = {}

    for _, axial in HexagonUtil.Hexagon(radius) do
        allTiles[HexagonUtil.Key(axial)] = axial
    end

    local function FindBestSpawn(): Axial
        local dist: {[string]: number} = {}

        -- Center Tile
        dist[HexagonUtil.Key(HexagonUtil.Axial(0, 0))] = 0
    
        -- Owned Tiles
        for key, owner in tileOwnership do
            if owner then
                dist[key] = 0
            end
        end

        -- Selected Tiles
        for key, selector in tileSelection do
            if selector then
                dist[key] = 0
            end
        end

        -- Border Tiles
        for key, _ in border do
            dist[key] = 0
        end

        local queue = Queue()

        for key, _ in dist do
            queue.Push(key)
        end

        while not queue.IsEmpty() do
            local key = queue.Pop() :: string
            local currentDist = dist[key] :: number

            if not neighborLookup[key] then
                print("No neighbors for key: " .. key)
            end

            for neighborKey, _ in neighborLookup[key] do
                if not dist[neighborKey] then
                    dist[neighborKey] = currentDist + 1
                    queue.Push(neighborKey)
                end
            end
        end

        local bestKey = next(dist) :: string

        local bestDist = dist[bestKey] :: number

        for key, d in dist do
            if d > bestDist then
                bestKey = key
                bestDist = d
            end
        end

        return allTiles[bestKey] :: Axial
    end

    local selectionChanged: Signal<Axial, HexagonPlayer?> = Signal(scope)
    local ownerChanged: Signal<Axial, HexagonPlayer?> = Signal(scope)

    local function SelectTile(player: HexagonPlayer, axial: Axial)
        local key = HexagonUtil.Key(axial)

        local currentSelector = tileSelection[key]

        if currentSelector == player then
            return
        end

        if currentSelector then
            playerTileSelection[currentSelector][key] = nil
        end

        tileSelection[key] = player

        if not playerTileSelection[player] then
            playerTileSelection[player] = {}
        end

        playerTileSelection[player][key] = axial

        selectionChanged:Fire(axial, player)
    end

    local function DeselectTiles(player: HexagonPlayer): TileSet?
        local selections = playerTileSelection[player]

        if not selections then
            return nil
        end

        for key, axial in selections do
            tileSelection[key] = nil
            selectionChanged:Fire(axial, nil)
        end

        playerTileSelection[player] = nil
        return selections
    end

    local function ClearOwnership(player: HexagonPlayer)
        local ownership = playerTileOwnership[player]

        if not ownership then
            return
        end

        for key, axial in ownership do
            tileOwnership[key] = nil
            ownerChanged:Fire(axial, nil)
        end

        playerTileOwnership[player] = nil
    end

    local function ClaimTiles(player: HexagonPlayer, tiles: TileSet)
        for key, axial in tiles do
            local currentOwner = tileOwnership[key]

            if currentOwner == player then
                continue
            end

            if currentOwner then
                playerTileOwnership[currentOwner][key] = nil
            end

            tileOwnership[key] = player

            if not playerTileOwnership[player] then
                playerTileOwnership[player] = {}
            end

            playerTileOwnership[player][key] = axial

            ownerChanged:Fire(axial, player)
        end
    end

    local function ClaimRadius(player: HexagonPlayer, center: Axial, claimRadius: number)
        local toClaim = {}

        for _, axial in HexagonUtil.Hexagon(claimRadius) do
            local claimAxial = HexagonUtil.Axial(center.Q + axial.Q, center.R + axial.R)

            if not HexagonUtil.IsInBounds(claimAxial, radius) then
                continue
            end

            toClaim[HexagonUtil.Key(claimAxial)] = claimAxial
        end

        ClaimTiles(player, toClaim)
    end

    local function FindUnreachableTiles(player: HexagonPlayer): TileSet
        local visited: Set<string> = {}
        local stack: {string} = {}

        for _, axial in border do
            local key = HexagonUtil.Key(axial)
            visited[key] = true
            table.insert(stack, key)
        end

        while next(stack) do
            local key = table.remove(stack) :: string

            if tileOwnership[key] == player then
                continue
            end

            for otherKey, _ in neighborLookup[key] do
                if visited[otherKey] then
                    continue
                end

                visited[otherKey] = true
                table.insert(stack, otherKey)
            end
        end

        local remainingTiles: TileSet = {}

        for key, axial in allTiles do
            if not visited[key] then
                remainingTiles[key] = axial
            end
        end

        return remainingTiles
    end

    local function FinishSelection(player: HexagonPlayer): TileSet?
        local selections = DeselectTiles(player)

        if not selections then
            return nil
        end

        local tilesBefore = Copy(playerTileOwnership[player] or {})

        ClaimTiles(player, selections)

        local unreachable = FindUnreachableTiles(player)
        ClaimTiles(player, unreachable)
 
        local innerClaimed = {}

        for key, axial in unreachable do
            if not tilesBefore[key] then
                innerClaimed[key] = axial
            end
        end

        return innerClaimed
    end

    local function RemoveFromGame(player: HexagonPlayer)
        DeselectTiles(player)
        ClearOwnership(player)
    end

    local self: HexagonInteractionWorld = {
        GetSelector = GetSelector,
        GetOwner = GetOwner,

        GetOwnedTiles = GetOwnedTiles,
        GetSelectedTiles = GetSelectedTiles,

        FindBestSpawn = FindBestSpawn,

        ClaimTiles = ClaimTiles,
        ClaimRadius = ClaimRadius,

        SelectTile = SelectTile,
        FinishSelection = FinishSelection,
        RemoveFromGame = RemoveFromGame,

        SelectionChanged = selectionChanged,
        OwnerChanged = ownerChanged,
    }

    return self
end

return HexagonInteractionWorld