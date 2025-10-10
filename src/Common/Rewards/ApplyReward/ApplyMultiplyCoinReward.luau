local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage.Common

local CommonPlayer = require(Common.Player.CommonPlayer)
type CommonPlayer = CommonPlayer.CommonPlayer

local Rewards = require(Common.Rewards.Rewards)
type MultiplyCoinReward = Rewards.MultiplyCoinReward

local function ApplyMultiplyCoinReward(player: CommonPlayer, reward: MultiplyCoinReward)
    player.Coins.MultiplyCoins(reward.Multiplier)
end

return ApplyMultiplyCoinReward
