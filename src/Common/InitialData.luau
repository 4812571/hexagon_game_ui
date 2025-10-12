--!strict
--!native

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage.Common

local PlayerData = require(Common.Player.PlayerData)
local HexagonData = require(Common.Hexagon.HexagonData)

export type PlayerData = PlayerData.PlayerData
export type HexagonData = HexagonData.HexagonData

export type InitialData = {
    JoinTime: number,

    Hexagon: HexagonData,
    Player: PlayerData,
}

return nil
