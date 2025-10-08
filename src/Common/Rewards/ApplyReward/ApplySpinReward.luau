local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common

local Fusion = require(Packages.Fusion)
local peek = require(Fusion.peek)

local CommonPlayer = require(Common.Player.CommonPlayer)
type CommonPlayer = CommonPlayer.CommonPlayer

local Rewards = require(Common.Rewards.Rewards)
type SpinReward = Rewards.SpinReward

local function ApplySpinReward(player: CommonPlayer, reward: SpinReward)
    player.Spins.Spins:set(peek(player.Spins) + reward.Amount)
end

return ApplySpinReward
