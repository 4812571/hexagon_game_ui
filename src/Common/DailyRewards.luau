local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage.Common

local Rewards = require(Common.Rewards.Rewards)
local BombReward = Rewards.BombReward
local CoinReward = Rewards.CoinReward
local SpinReward = Rewards.SpinReward

export type BombReward = Rewards.BombReward
export type SpinReward = Rewards.SpinReward
export type CoinReward = Rewards.CoinReward

export type DailyReward = 
    | BombReward
    | SpinReward
    | CoinReward

local DailyRewards: {DailyReward} = {
    BombReward("Bomb", 1),
    SpinReward(3),
    CoinReward(20000),
    BombReward("Bomb", 5),
    CoinReward(50000),
    SpinReward(10),
    BombReward("Nuke", 3),
}

return DailyRewards