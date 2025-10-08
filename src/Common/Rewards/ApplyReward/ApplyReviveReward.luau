local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common

local Fusion = require(Packages.Fusion)
local peek = require(Fusion.peek)

local CommonPlayer = require(Common.Player.CommonPlayer)
type CommonPlayer = CommonPlayer.CommonPlayer

local Rewards = require(Common.Rewards.Rewards)
type ReviveReward = Rewards.ReviveReward

local function ApplyReviveReward(player: CommonPlayer, reward: ReviveReward)
    player.Revives.Revives:set(peek(player.Revives.Revives) + reward.Amount)
end

return ApplyReviveReward
