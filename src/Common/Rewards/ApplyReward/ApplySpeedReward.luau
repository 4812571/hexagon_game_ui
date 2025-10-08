local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage.Common

local CommonPlayer = require(Common.Player.CommonPlayer)
type CommonPlayer = CommonPlayer.CommonPlayer

local Rewards = require(Common.Rewards.Rewards)
type SpeedReward = Rewards.SpeedReward

local function ApplySpeedReward(player: CommonPlayer, reward: SpeedReward)
    print("[ApplySpeedReward] Applying speed reward.")
end

return ApplySpeedReward
