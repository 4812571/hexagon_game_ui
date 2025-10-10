local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage.Common

local CoinsData = require(Common.Coins.CoinsData)
type CoinsData = CoinsData.CoinsData

local DefaultCoinsData: CoinsData = {
    Coins = 0,
    IncomeMultiplier = 1,
}

return DefaultCoinsData