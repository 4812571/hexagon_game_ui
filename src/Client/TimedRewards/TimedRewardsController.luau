--!strict
--!native

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)
type Scope = Fusion.Scope<typeof(Fusion)>

local ApplyReward = require(Common.Rewards.ApplyReward)
local TimedRewards = require(Common.TimedRewards.TimedRewards)

local ClientPlayer = require(Client.Player.ClientPlayer)
type ClientPlayer = ClientPlayer.ClientPlayer

export type TimedRewardsController = {
    TryClaim: (rewardIndex: number, instant: number) -> boolean,
}

local function TimedRewardsController(scope: Scope, player: ClientPlayer): TimedRewardsController
    local function TryClaim(rewardIndex: number, instant: number): boolean
        if not player.TimedRewards.CanClaim(rewardIndex, instant) then
            return false
        end

        player.TimedRewards.PerformClaim(rewardIndex)
        ApplyReward(player, TimedRewards[rewardIndex].Reward :: TimedRewards.TimedReward)
        return true
    end

    local self: TimedRewardsController = {
        TryClaim = TryClaim,
    }

    return self
end

return TimedRewardsController
