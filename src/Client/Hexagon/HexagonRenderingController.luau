--!strict
--!native

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
    Start: () -> (),
}

local function HexagonRenderingController(scope: Scope, initialData: InitialData)
    local hexagons = LoadHexagons()
    local renderingWorld = HexagonRenderingWorld()

    for axial, hexagonModel in hexagons do
        renderingWorld.AddHexagonTile(axial, hexagonModel)
    end

    for id, axials in initialData.Owned do
        for _, axial in axials do
            renderingWorld.SetHexagonTile(axial, id)
        end
    end

    for id, axials in initialData.Selected do
        for _, axial in axials do
            renderingWorld.SetHexagonSelection(axial, id)
        end
    end

    for _, hexagonModel in hexagons do
        hexagonModel.Parent = workspace
    end

    local function OnSkinRegistered(id: number, color: Color3, imageId: string?)
        local entry: HexagonRenderingWorld.SkinRegistryEntry = {
            Color = color,
            ImageId = imageId,
        }

        renderingWorld.RegisterSkin(id, entry)
    end

    local function OnSkinUnregistered(id: number)
        renderingWorld.UnregisterSkin(id)
    end

    local function OnSkinImageChanged(id: number, imageId: string?)
        renderingWorld.SetImage(id, imageId)
    end

    local function OnHexagonsFilled(id: number?, axials: {Axial})
        print(`Filling {#axials} hexagons with skin ID {id}`)

        for _, axial in axials do
            renderingWorld.SetHexagonTile(axial, id)
        end
    end

    local function OnHexagonsSelected(id: number?, axials: {Axial})
        for _, axial in axials do
            renderingWorld.SetHexagonSelection(axial, id)
        end
    end

    local function Start()
        NetworkClient.Hexagon.SkinRegistered.On(OnSkinRegistered)
        NetworkClient.Hexagon.SkinUnregistered.On(OnSkinUnregistered)
        NetworkClient.Hexagon.SkinImageChanged.On(OnSkinImageChanged)

        NetworkClient.Hexagon.HexagonsFilled.On(OnHexagonsFilled)
        NetworkClient.Hexagon.HexagonsSelected.On(OnHexagonsSelected)
    end

    local self: HexagonRenderingController = {
        Start = Start,
    }

    return self
end

return HexagonRenderingController
