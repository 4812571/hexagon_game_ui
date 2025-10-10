local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage.Common

local CommonPlayer = require(Common.Player.CommonPlayer)
type CommonPlayer = CommonPlayer.CommonPlayer

local Rewards = require(Common.Rewards.Rewards)
type CoinReward = Rewards.CoinReward

local function ApplyCoinReward(player: CommonPlayer, reward: CoinReward)
    player.Coins.AwardCoins(reward.Amount)
end

return ApplyCoinReward
