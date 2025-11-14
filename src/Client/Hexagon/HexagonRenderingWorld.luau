--!strict
--!native

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage.Common

local HexagonUtil = require(Common.Hexagon.HexagonUtil)
type Axial = HexagonUtil.Axial

export type SkinRegistryEntry = {
    Color: Color3,
    ImageId: string?,
}

export type HexagonRenderingWorld = {
    AddHexagonTile: (axial: Axial, model: Model) -> (),

    RegisterSkin: (id: number, entry: SkinRegistryEntry) -> (),
    UnregisterSkin: (id: number) -> (),
    
    SetImage: (id: number, imageId: string?) -> (),

    SetHexagonTile: (axial: Axial, id: number?) -> (),
    SetHexagonSelection: (axial: Axial, id: number?) -> (),
}

local function HexagonRenderingWorld()
    local hexagonTiles: {[string]: Model} = {}
    local ownership: {[string]: number?} = {}

    local function AddHexagonTile(axial: Axial, model: Model)
        hexagonTiles[HexagonUtil.Key(axial)] = model
    end

    local skins: {[number]: SkinRegistryEntry} = {}

    local function RegisterSkin(id: number, entry: SkinRegistryEntry)
        skins[id] = entry
    end

    local function UnregisterSkin(id: number)
        skins[id] = nil
    end

    local function SetImage(id: number, imageId: string?)
        local entry = skins[id]

        if not entry then
            return
        end

        entry.ImageId = imageId 

        for key, ownerId in ownership do
            if ownerId ~= id then
                continue
            end

            local model = hexagonTiles[key]

            if not model then
                error("Hexagon tile does not exist for axial: " .. key)
            end

            model:SetAttribute("TileImage", imageId)
        end
    end

    local function SetHexagonTile(axial: Axial, id: number?)
        local key = HexagonUtil.Key(axial)

        local model = hexagonTiles[key]

        if not model then
            error("Hexagon tile does not exist for axial: " .. key)
        end

        ownership[key] = id

        local skin: SkinRegistryEntry? = if id then skins[id] else nil

        model:SetAttribute("IsOwned", id ~= nil)
        
        if skin then
            model:SetAttribute("TileColor", skin.Color)
            model:SetAttribute("TileImage", skin.ImageId)
        end
    end

    local function SetHexagonSelection(axial: Axial, id: number?)
        local model = hexagonTiles[HexagonUtil.Key(axial)]

        if not model then
            error("Hexagon tile does not exist for axial: " .. HexagonUtil.Key(axial))
        end

        model:SetAttribute("IsSelected", id ~= nil)

        local skin = if id then skins[id] else nil

        if skin then
            model:SetAttribute("SelectionColor", skin.Color)
        end
    end

    local self: HexagonRenderingWorld = {
        AddHexagonTile = AddHexagonTile,

        RegisterSkin = RegisterSkin,
        UnregisterSkin = UnregisterSkin,

        SetImage = SetImage,
        
        SetHexagonTile = SetHexagonTile,
        SetHexagonSelection = SetHexagonSelection,
    }

    return self
end

return HexagonRenderingWorld
