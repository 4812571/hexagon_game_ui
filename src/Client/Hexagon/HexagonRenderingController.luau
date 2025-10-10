--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)
type Scope = Fusion.Scope<unknown>

local HexagonConfig = require(Common.Hexagon.HexagonConfig)

local HexagonUtil = require(Common.Hexagon.HexagonUtil)
type Axial = HexagonUtil.Axial

local HexagonData = require(Common.Hexagon.HexagonData)
type InitialData = HexagonData.HexagonData

local NetworkClient = require(ReplicatedStorage.NetworkClient)

local HexagonRenderingWorld = require(Client.Hexagon.HexagonRenderingWorld)

local HexagonTile = ReplicatedStorage:WaitForChild("HexagonTile")

local function LoadHexagons(): {[Axial]: Model}
    local hexagons: {[Axial]: Model} = {}

    for _, axial in HexagonUtil.Hexagon(HexagonConfig.WorldRadius) do
        hexagons[axial] = HexagonTile:Clone()
    end

    for axial, hexagonModel in hexagons do
        hexagonModel:PivotTo(CFrame.new(HexagonUtil.AxialToWorld(axial) * HexagonConfig.HexagonSize))
    end

    return hexagons
end

export type HexagonRenderingController = {
    Init: () -> (),
}

local function HexagonRenderingController(scope: Scope, initialData: InitialData)
    local hexagons = LoadHexagons()
    local renderingWorld = HexagonRenderingWorld()

    for axial, hexagonModel in hexagons do
        renderingWorld.AddHexagonTile(axial, hexagonModel)
    end

    for axial, color in initialData.Owned do
        renderingWorld.SetHexagonTileColor(axial, color)
    end

    for axial, color in initialData.Selected do
        renderingWorld.SetHexagonSelectionColor(axial, color)
    end

    for _, hexagonModel in hexagons do
        hexagonModel.Parent = workspace
    end

    local function OnHexagonsColored(color: Color3?, axials: {Axial})
        for _, axial in axials do
            renderingWorld.SetHexagonTileColor(axial, color)
        end
    end

    local function Init()
        NetworkClient.Hexagon.HexagonsColored.On(OnHexagonsColored)

        NetworkClient.Hexagon.HexagonsSelected.On(function(color: Color3?, axials: {Axial})
            for _, axial in axials do
                renderingWorld.SetHexagonSelectionColor(axial, color)
            end
        end)
    end

    local self: HexagonRenderingController = {
        Init = Init,
    }

    return self
end

return HexagonRenderingController