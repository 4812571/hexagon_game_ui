local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common

local Fusion = require(Packages.Fusion)
local peek = require(Fusion.peek)

local CommonPlayer = require(Common.Player.CommonPlayer)
type CommonPlayer = CommonPlayer.CommonPlayer

local Rewards = require(Common.Rewards.Rewards)
type MultiplyCoinReward = Rewards.MultiplyCoinReward

local function ApplyMultiplyCoinReward(player: CommonPlayer, reward: MultiplyCoinReward)
    player.Coins.Coins:set(peek(player.Coins) * reward.Multiplier)
end

return ApplyMultiplyCoinReward
