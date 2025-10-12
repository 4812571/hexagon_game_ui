--!strict
--!native

local BombReward = require(script.BombReward)
local CoinReward = require(script.CoinReward)
local IncomeReward = require(script.IncomeReward)
local MultiplyCoinReward = require(script.MultiplyCoinReward)
local ReviveReward = require(script.ReviveReward)
local SpeedReward = require(script.SpeedReward)
local SpinReward = require(script.SpinReward)

export type BombReward = BombReward.BombReward
export type CoinReward = CoinReward.CoinReward
export type IncomeReward = IncomeReward.IncomeReward
export type MultiplyCoinReward = MultiplyCoinReward.MultiplyCoinReward
export type ReviveReward = ReviveReward.ReviveReward
export type SpeedReward = SpeedReward.SpeedReward
export type SpinReward = SpinReward.SpinReward

export type Reward =
    | BombReward
    | CoinReward
    | IncomeReward
    | MultiplyCoinReward
    | ReviveReward
    | SpeedReward
    | SpinReward

local Rewards = {
    BombReward = BombReward,
    CoinReward = CoinReward,
    IncomeReward = IncomeReward,
    MultiplyCoinReward = MultiplyCoinReward,
    ReviveReward = ReviveReward,
    SpeedReward = SpeedReward,
    SpinReward = SpinReward,
}

return Rewards
