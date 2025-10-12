--!strict
--!native

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage.Common

local Rewards = require(Common.Rewards.Rewards)
local BombReward = Rewards.BombReward  
local CoinReward = Rewards.CoinReward
local IncomeReward = Rewards.IncomeReward
local SpeedReward = Rewards.SpeedReward
local SpinReward = Rewards.SpinReward

export type BombReward = Rewards.BombReward
export type CoinReward = Rewards.CoinReward
export type IncomeReward = Rewards.IncomeReward
export type SpeedReward = Rewards.SpeedReward
export type SpinReward = Rewards.SpinReward

export type LevelReward = 
    | BombReward
    | CoinReward
    | IncomeReward
    | SpeedReward
    | SpinReward

local LevelRewards: {LevelReward} = {
    CoinReward(2000),
    CoinReward(4000),
    BombReward("Bomb", 1),
    IncomeReward(5),
    SpinReward(1),
    CoinReward(8000),
    BombReward("GoldBomb", 1),
    SpeedReward(4),
    BombReward("Nuke", 1),
    SpinReward(1),
    CoinReward(10000),
    SpeedReward(4),
    BombReward("Bomb", 1),
    IncomeReward(5),
    CoinReward(12000),
    SpeedReward(4),
    BombReward("GoldBomb", 1),
    CoinReward(15000),
    IncomeReward(5),
    BombReward("Bomb", 1),
    CoinReward(18000),
    SpeedReward(4),
    BombReward("Bomb", 3),
    IncomeReward(5),
    SpinReward(2),
    SpeedReward(4),
    CoinReward(20000),
    SpeedReward(4),
    IncomeReward(5),
    BombReward("GoldBomb", 2),
    CoinReward(23000),
    SpeedReward(4),
    BombReward("Bomb", 3),
    IncomeReward(5),
    CoinReward(25000),
    SpeedReward(4),
    BombReward("Nuke", 1),
    SpinReward(2),
    IncomeReward(5),
    SpinReward(2),
    CoinReward(25000),
    SpeedReward(4),
    BombReward("Bomb", 3),
    IncomeReward(5),
    CoinReward(25000),
    SpeedReward(4),
    BombReward("GoldBomb", 2),
    SpeedReward(4),
    IncomeReward(5),
    CoinReward(26000),
    SpinReward(3),
    BombReward("Bomb", 3),
    BombReward("Bomb", 3),
    IncomeReward(5),
    CoinReward(27000),
    SpeedReward(4),
    BombReward("Nuke", 1),
    SpeedReward(4),
    IncomeReward(5),
    BombReward("GoldBomb", 3),
    CoinReward(28000),
    SpeedReward(4),
    BombReward("Bomb", 1),
    IncomeReward(5),
    SpinReward(2),
    SpeedReward(4),
    CoinReward(29000),
    SpeedReward(4),
    BombReward("Bomb", 2),
    BombReward("Bomb", 2),
    CoinReward(30000),
    SpeedReward(4),
    BombReward("Bomb", 3),
    IncomeReward(5),
    CoinReward(33000),
    SpeedReward(4),
    BombReward("GoldBomb", 2),
    SpeedReward(4),
    IncomeReward(5),
    SpinReward(3),
    CoinReward(37000),
    BombReward("GoldBomb", 2),
    BombReward("Bomb", 4),
    IncomeReward(5),
    BombReward("Nuke", 1),
    BombReward("Bomb", 3),
    CoinReward(40000),
    BombReward("GoldBomb", 3),
    IncomeReward(5),
    CoinReward(43000),
    SpinReward(4),
    SpeedReward(4),
    BombReward("Bomb", 5),
    IncomeReward(5),
    CoinReward(45000),
    CoinReward(50000),
    CoinReward(60000),
    BombReward("GoldBomb", 4),
    IncomeReward(5),
    BombReward("Nuke", 3),
}

return LevelRewards
