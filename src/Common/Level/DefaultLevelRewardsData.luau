--!strict
--!native

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage.Common

local LevelRewardsData = require(Common.Level.LevelRewardsData)
type LevelRewardsData = LevelRewardsData.LevelRewardsData

local DefaultLevelRewardsData: LevelRewardsData = {
    ClaimedIndexes = {},
}

return DefaultLevelRewardsData
