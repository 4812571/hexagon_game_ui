local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common

local Fusion = require(Packages.Fusion)
local peek = Fusion.peek

local CommonPlayer = require(Common.Player.CommonPlayer)
type CommonPlayer = CommonPlayer.CommonPlayer

local Rewards = require(Common.Rewards.Rewards)
type IncomeReward = Rewards.IncomeReward

local function Add(value: Fusion.Value<number>, amount: number)
    value:set(peek(value) + amount)
end

local function Percent(n: number): number
    return n * 0.01
end

local function ApplyIncomeReward(player: CommonPlayer, reward: IncomeReward)
    Add(player.Coins.IncomeMultiplier, Percent(reward.Percent))
end

return ApplyIncomeReward
