local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage.Common

local BombReward = require(Common.Rewards.BombReward)
local CoinReward = require(Common.Rewards.CoinReward)
local SpinReward = require(Common.Rewards.SpinReward)
local MultiplyCoinReward = require(Common.Rewards.MultiplyCoinReward)
local ReviveReward = require(Common.Rewards.ReviveReward)

export type SpinReward = 
    | BombReward.BombReward
    | CoinReward.CoinReward
    | SpinReward.SpinReward
    | MultiplyCoinReward.MultiplyCoinReward
    | ReviveReward.ReviveReward

export type SpinRewardEntry = {
    Weight: number,
    Value: SpinReward,
}

local function SpinRewardEntry(weight: number, reward: SpinReward): SpinRewardEntry
    local spinReward = {
        Weight = weight,
        Value = reward,
    }

    return spinReward
end

local SpinRewards: {SpinRewardEntry} = {
    SpinRewardEntry(1, BombReward("Nuke", 1)),
    SpinRewardEntry(14, CoinReward(10000)),
    SpinRewardEntry(14, BombReward("Bomb", 3)),
    SpinRewardEntry(10, ReviveReward(1)),
    SpinRewardEntry(15, SpinReward(1)),
    SpinRewardEntry(14, CoinReward(5000)),
    SpinRewardEntry(14, BombReward("Bomb", 1)),
    SpinRewardEntry(2, MultiplyCoinReward(5)),
    SpinRewardEntry(10, BombReward("Bomb", 2)),
    SpinRewardEntry(15, CoinReward(2000)),
}

return SpinRewards
