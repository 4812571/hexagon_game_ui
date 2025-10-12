--!strict
--!native

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage.Common

local SpinsData = require(Common.Spins.SpinsData)
type SpinsData = SpinsData.SpinsData

local DefaultSpinsData: SpinsData = {
    Spins = 0,
    PendingReward = nil,
}

return DefaultSpinsData
