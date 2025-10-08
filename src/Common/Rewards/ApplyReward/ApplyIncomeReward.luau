local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage.Common

local CommonPlayer = require(Common.Player.CommonPlayer)
type CommonPlayer = CommonPlayer.CommonPlayer

local Rewards = require(Common.Rewards.Rewards)
type IncomeReward = Rewards.IncomeReward

local function ApplyIncomeReward(player: CommonPlayer, reward: IncomeReward)
    print("[ApplyIncomeReward] Applying income reward.")
end

return ApplyIncomeReward
