local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage.Common

local BombReward = require(Common.Rewards.BombReward)
local CoinReward = require(Common.Rewards.CoinReward)
local SpinReward = require(Common.Rewards.SpinReward)

export type BombReward = BombReward.BombReward
export type SpinReward = SpinReward.SpinReward
export type CoinReward = CoinReward.CoinReward

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