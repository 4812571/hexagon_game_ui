local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common

local Fusion = require(Packages.Fusion)
local peek = require(Fusion.peek)

local CommonPlayer = require(Common.Player.CommonPlayer)
type CommonPlayer = CommonPlayer.CommonPlayer

local Rewards = require(Common.Rewards.Rewards)
type CoinReward = Rewards.CoinReward

local function ApplyCoinReward(player: CommonPlayer, reward: CoinReward)
    player.Coins.Coins:set(peek(player.Coins) + reward.Amount)
end

return ApplyCoinReward
