local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)

local Icons = require(Common.Icons)

local TimedRewards = require(Common.TimedRewards)
type TimedRewardData = TimedRewards.TimedRewardData

local Window = require(Client.Interface.Window)

export type TimedRewardEntry = {
    RewardData: TimedRewardData,
    Claimed: Fusion.UsedAs<boolean>,
    RemainingTime: Fusion.UsedAs<number>,
}

export type TimedRewardsWindowProps = {
    Scope: Fusion.Scope<typeof(Fusion)>,

    Rewards: Fusion.UsedAs<{TimedRewardEntry}>,

    OnClaim: (index: number, entry: TimedRewardEntry) -> (),
}

local function TimedRewardsWindow(props: TimedRewardsWindowProps)
    return Window {
        Scope = props.Scope,
        Title = "Rewards",
        Icon = Icons.Gift,
    }
end

return TimedRewardsWindow