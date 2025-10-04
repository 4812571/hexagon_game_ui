local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage.Common

local HexagonUtil = require(Common.Hexagon.HexagonUtil)
type Axial = HexagonUtil.Axial

export type HexagonData = {
    Owned: {[Axial]: Color3},
    Selected: {[Axial]: Color3},
}

return nil