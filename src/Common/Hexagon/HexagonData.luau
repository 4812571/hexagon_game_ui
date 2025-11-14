--!strict
--!native

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage.Common

local HexagonUtil = require(Common.Hexagon.HexagonUtil)
type Axial = HexagonUtil.Axial

type SkinRegistryEntry = {
    Color: Color3,
    ImageId: string?,
}

export type HexagonData = {
    Skins: {[number]: SkinRegistryEntry},
    Owned: {[number]: {Axial}},
    Selected: {[number]: {Axial}},
}

return nil
