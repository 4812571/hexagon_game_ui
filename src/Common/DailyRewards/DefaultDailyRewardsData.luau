local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage.Common

local DailyRewardsData = require(Common.DailyRewards.DailyRewardsData)
type DailyRewardsData = DailyRewardsData.DailyRewardsData

local DefaultDailyRewardsData: DailyRewardsData = {
    LastClaim = 0,
    NextClaimIndex = 1,
}

return DefaultDailyRewardsData
