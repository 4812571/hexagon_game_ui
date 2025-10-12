--!strict
--!native

local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Server = ServerScriptService.Server

local Fusion = require(Packages.Fusion)
type Scope = Fusion.Scope<unknown>

local HexagonPlayer = require(Server.Hexagon.HexagonPlayer)
type HexagonPlayer = HexagonPlayer.HexagonPlayer

local Signal = require(Common.Signal)
type Signal<T...> = Signal.Signal<T...>

local HexagonUtil = require(Common.Hexagon.HexagonUtil)
type Axial = HexagonUtil.Axial

local TileSet = require(Common.Hexagon.TileSet)
type TileSet = TileSet.TileSet

local HexagonData = require(Common.Hexagon.HexagonData)
type HexagonData = HexagonData.HexagonData

type ColorRecord = Color3 | "None"

type HexagonColorRecord = {
    Axial: Axial,
    Color: ColorRecord,
}

local function Record(axial: Axial, color: Color3?): HexagonColorRecord
    local record: HexagonColorRecord = {
        Axial = axial,
        Color = if color then color else "None",
    }

    return record
end

local function ToColor(color: ColorRecord): Color3?
    if color ~= "None" then
        return color
    else
        return nil
    end
end

export type HexagonRenderer = {
    SetTileColor: (Axial, Color3?) -> (),
    SetSelectionColor: (Axial, Color3?) -> (),

    TilesChanged: Signal<Color3?, {Axial}>,
    SelectionsChanged: Signal<Color3?, {Axial}>,
}

local function GroupByColor(records: {[string]: HexagonColorRecord}): {[ColorRecord]: {Axial}} 
    local groups: {[ColorRecord]: {Axial}} = {}

    for _, record in records do
        if not groups[record.Color] then
            groups[record.Color] = {}
        end

        table.insert(groups[record.Color], record.Axial)
    end

    return groups
end

local function HexagonRenderer(scope: Scope): HexagonRenderer
    local tileChanges: {[string]: HexagonColorRecord} = {}
    local selectionChanges: {[string]: HexagonColorRecord} = {}

    local tileChangesSignal: Signal<Color3?, {Axial}> = Signal(scope)
    local selectionChangesSignal: Signal<Color3?, {Axial}> = Signal(scope)

    local isScheduled = false

    local function Dispatch()
        local tileGroups: {[ColorRecord]: {Axial}} = GroupByColor(tileChanges)
        
        for color, axials in tileGroups do
            tileChangesSignal:Fire(ToColor(color :: ColorRecord), axials)
        end

        local selectionGroups: {[ColorRecord]: {Axial}} = GroupByColor(selectionChanges)

        for color, axials in selectionGroups do
            selectionChangesSignal:Fire(ToColor(color :: ColorRecord), axials)
        end

        tileChanges = {}
        selectionChanges = {}
        isScheduled = false
    end

    local function Schedule()
        if isScheduled then
            return
        end

        isScheduled = true
        task.defer(Dispatch)
    end

    local function SetTileColor(axial: Axial, color: Color3?)
        tileChanges[HexagonUtil.Key(axial)] = Record(axial, color)
        Schedule()
    end

    local function SetSelectionColor(axial: Axial, color: Color3?)
        selectionChanges[HexagonUtil.Key(axial)] = Record(axial, color)
        Schedule()
    end

    local self = {
        SetTileColor = SetTileColor,
        SetSelectionColor = SetSelectionColor,

        TilesChanged = tileChangesSignal,
        SelectionsChanged = selectionChangesSignal,
    }

    return self
end

return HexagonRenderer
