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

type Record<T> = T | "None"

type HexagonRecord<T> = {
    Axial: Axial,
    Value: Record<T>,
}

local function HexagonRecord<T>(axial: Axial, value: T?): HexagonRecord<T>
    local record: HexagonRecord<T> = {
        Axial = axial,
        Value = if value then value else "None",
    }

    return record
end

local function ToValue<T>(record: Record<T>): T?
    if record ~= "None" then
        return record
    else
        return nil
    end
end

type SkinRegistryEntry = {
    Color: Color3,
    ImageId: string?,
}

export type HexagonRenderer = {
    RegisterSkin: (Color3, string?) -> number,
    UnregisterSkin: (number) -> (),
    SetImage: (number, string?) -> (),

    GetSkins: () -> {[number]: SkinRegistryEntry},

    SkinRegistered: Signal<number, Color3, string?>,
    SkinUnregistered: Signal<number>,
    SkinImageChanged: Signal<number, string?>,

    SetTile: (Axial, number?) -> (),
    SetSelection: (Axial, number?) -> (),

    TilesChanged: Signal<number?, {Axial}>,
    SelectionsChanged: Signal<number?, {Axial}>,
}

local function GroupByValue<T>(records: {[string]: HexagonRecord<T>}): {[Record<T>]: {Axial}} 
    local groups: {[Record<T>]: {Axial}} = {}

    for _, record in records do
        if not groups[record.Value] then
            groups[record.Value] = {}
        end

        table.insert(groups[record.Value], record.Axial)
    end

    return groups
end

local function HexagonRenderer(scope: Scope): HexagonRenderer
    local nextSkinId = 1
    local skins: {[number]: SkinRegistryEntry} = {}

    local skinRegisteredSignal: Signal<number, Color3, string?> = Signal(scope)
    local skinUnregisteredSignal: Signal<number> = Signal(scope)
    local skinImageChangedSignal: Signal<number, string?> = Signal(scope)

    local function RegisterSkin(color: Color3, imageId: string?): number
        local skinId = nextSkinId
        nextSkinId += 1

        skins[skinId] = {
            Color = color,
            ImageId = imageId,
        }

        skinRegisteredSignal:Fire(skinId, color, imageId)

        return skinId
    end

    local function UnregisterSkin(skinId: number)
        skins[skinId] = nil

        skinUnregisteredSignal:Fire(skinId)
    end

    local function SetImage(skinId: number, imageId: string?)
        local skin = skins[skinId]

        if not skin then
            error("Skin ID not registered: " .. tostring(skinId))
        end

        skin.ImageId = imageId
        skinImageChangedSignal:Fire(skinId, imageId)
    end

    local function GetSkins(): {[number]: SkinRegistryEntry}
        return table.clone(skins)
    end

    local tileChanges: {[string]: HexagonRecord<number>} = {}
    local selectionChanges: {[string]: HexagonRecord<number>} = {}

    local tileChangesSignal: Signal<number?, {Axial}> = Signal(scope)
    local selectionChangesSignal: Signal<number?, {Axial}> = Signal(scope)

    local isScheduled = false

    local function Dispatch()
        local tileGroups: {[Record<number>]: {Axial}} = GroupByValue(tileChanges)
        
        for color, axials in tileGroups do
            tileChangesSignal:Fire(ToValue(color :: Record<number>), axials)
        end

        local selectionGroups: {[Record<number>]: {Axial}} = GroupByValue(selectionChanges)

        for color, axials in selectionGroups do
            selectionChangesSignal:Fire(ToValue(color :: Record<number>), axials)
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

    local function SetTile(axial: Axial, color: number?)
        tileChanges[HexagonUtil.Key(axial)] = HexagonRecord(axial, color)
        Schedule()
    end

    local function SetSelection(axial: Axial, color: number?)
        selectionChanges[HexagonUtil.Key(axial)] = HexagonRecord(axial, color)
        Schedule()
    end

    local self: HexagonRenderer = {
        RegisterSkin = RegisterSkin,
        UnregisterSkin = UnregisterSkin,
        SetImage = SetImage,

        GetSkins = GetSkins,

        SkinRegistered = skinRegisteredSignal,
        SkinUnregistered = skinUnregisteredSignal,
        SkinImageChanged = skinImageChangedSignal,

        SetTile = SetTile,
        SetSelection = SetSelection,

        TilesChanged = tileChangesSignal,
        SelectionsChanged = selectionChangesSignal,
    }

    return self
end

return HexagonRenderer
