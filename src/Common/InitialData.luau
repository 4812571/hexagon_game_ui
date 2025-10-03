local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage.Common

local HexagonInitialData = require(Common.Hexagon.HexagonInitialData)

export type HexagonInitialData = HexagonInitialData.HexagonInitialData

export type InitialData = {
    JoinTime: number,

    Hexagon: HexagonInitialData,
}

return nil