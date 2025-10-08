local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage.Common

local Rewards = require(Common.Rewards)
type Reward = Rewards.Reward

export type SpinsData = {
    Spins: number,
    PendingReward: Reward?,
}

return nil
