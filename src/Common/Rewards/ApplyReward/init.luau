--!strict
--!native

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage.Common

local Rewards = require(Common.Rewards.Rewards)
type Reward = Rewards.Reward

local CommonPlayer = require(Common.Player.CommonPlayer)
type CommonPlayer = CommonPlayer.CommonPlayer

local ApplyBombReward = require(script.ApplyBombReward)
local ApplyCoinReward = require(script.ApplyCoinReward)
local ApplyIncomeReward = require(script.ApplyIncomeReward)
local ApplyMultiplyCoinReward = require(script.ApplyMultiplyCoinReward)
local ApplyReviveReward = require(script.ApplyReviveReward)
local ApplySpeedReward = require(script.ApplySpeedReward)
local ApplySpinReward = require(script.ApplySpinReward)

local function ApplyReward(player: CommonPlayer, reward: Reward)
    if reward.Type == "Bomb" then
        return ApplyBombReward(player, reward)
    end

    if reward.Type == "Coin" then
        return ApplyCoinReward(player, reward)
    end

    if reward.Type == "Income" then
        return ApplyIncomeReward(player, reward)
    end

    if reward.Type == "MultiplyCoin" then
        return ApplyMultiplyCoinReward(player, reward)
    end

    if reward.Type == "Revive" then
        return ApplyReviveReward(player, reward)
    end

    if reward.Type == "Speed" then
        return ApplySpeedReward(player, reward)
    end

    if reward.Type == "Spin" then
        return ApplySpinReward(player, reward)
    end

    error("[ApplyReward] Unknown reward type: " .. tostring(reward.Type))
end

return ApplyReward
