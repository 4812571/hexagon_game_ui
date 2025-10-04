local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage.Common

local Duration = require(Common.Duration)

local CoinReward = require(Common.Rewards.CoinReward)
local BombReward = require(Common.Rewards.BombReward)
local SpinReward = require(Common.Rewards.SpinReward)
local ReviveReward = require(Common.Rewards.ReviveReward)

export type CoinReward = CoinReward.CoinReward
export type BombReward = BombReward.BombReward
export type SpinReward = SpinReward.SpinReward
export type ReviveReward = ReviveReward.ReviveReward

export type TimedReward =
    | CoinReward
    | BombReward
    | SpinReward
    | ReviveReward

export type TimedRewardData = {
    Duration: number,
    Reward: TimedReward,
}

local function TimedRewardData(duration: number, reward: TimedReward): TimedRewardData
    local timedReward = {
        Duration = duration,
        Reward = reward,
    }

    return timedReward
end

local TimedRewards: {TimedRewardData} = {
    TimedRewardData(2 * Duration.Minute, CoinReward(2500)),
    TimedRewardData(4 * Duration.Minute, BombReward("Bomb", 1)),
    TimedRewardData(6 * Duration.Minute, CoinReward(5000)),
    TimedRewardData(8 * Duration.Minute, SpinReward(1)),
    TimedRewardData(10 * Duration.Minute, BombReward("GoldBomb", 1)),
    TimedRewardData(13 * Duration.Minute, SpinReward(2)),
    TimedRewardData(16 * Duration.Minute, CoinReward(15000)),
    TimedRewardData(19 * Duration.Minute, ReviveReward(1)),
    TimedRewardData(22 * Duration.Minute, CoinReward(25000)),
    TimedRewardData(25 * Duration.Minute, SpinReward(3)),
    TimedRewardData(30 * Duration.Minute, BombReward("Bomb", 3)),
    TimedRewardData(35 * Duration.Minute, CoinReward(40000)),
    TimedRewardData(40 * Duration.Minute, BombReward("GoldBomb", 2)),
    TimedRewardData(45 * Duration.Minute, SpinReward(5)),
    TimedRewardData(60 * Duration.Minute, SpinReward(10)),
}

return TimedRewards