local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage.Common

local HexagonUtil = require(Common.Hexagon.HexagonUtil)
type Axial = HexagonUtil.Axial

export type HexagonRenderingWorld = {
    AddHexagonTile: (axial: Axial, model: Model) -> (),
    SetHexagonTileColor: (axial: Axial, color: Color3?) -> (),
    SetHexagonSelectionColor: (axial: Axial, color: Color3?) -> (),
}

local function HexagonRenderingWorld()
    local hexagonTiles: {[string]: Model} = {}

    local function AddHexagonTile(axial: Axial, model: Model)
        hexagonTiles[HexagonUtil.Key(axial)] = model
    end

    local function SetHexagonTileColor(axial: Axial, color: Color3?)
        local model = hexagonTiles[HexagonUtil.Key(axial)]

        if model then
            model:SetAttribute("IsOwned", color ~= nil)

            if color then
                model:SetAttribute("TileColor", color)
            end
        end
    end

    local function SetHexagonSelectionColor(axial: Axial, color: Color3?)
        local model = hexagonTiles[HexagonUtil.Key(axial)]

        if model then
            model:SetAttribute("IsSelected", color ~= nil)

            if color then
                model:SetAttribute("SelectionColor", color)
            end
        end
    end

    local self: HexagonRenderingWorld = {
        AddHexagonTile = AddHexagonTile,
        SetHexagonTileColor = SetHexagonTileColor,
        SetHexagonSelectionColor = SetHexagonSelectionColor,
    }

    return self
end

return HexagonRenderingWorld