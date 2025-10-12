--!strict
--!native
--!nolint LocalShadow

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)

type Scope<T> = Fusion.Scope<typeof(Fusion) & T>

local Icons = require(Common.Icons)

local TimedRewards = require(Common.TimedRewards.TimedRewards)
type TimedRewardData = TimedRewards.TimedRewardData

local Window = require(Client.Interface.Window)

export type TimedRewardEntry = {
    RewardData: TimedRewardData,
    Claimed: Fusion.UsedAs<boolean>,
    RemainingTime: Fusion.UsedAs<number>,
}

export type TimedRewardsWindowProps = {
    Rewards: Fusion.UsedAs<{TimedRewardEntry}>,

    OnClaim: (index: number, entry: TimedRewardEntry) -> (),
}

local function TimedRewardsWindow<U>(scope: Scope<U>, props: TimedRewardsWindowProps)
    local scope = scope:innerScope {
        Window = Window,
    }

    return scope:Window {
        Title = "Rewards",
        Icon = Icons.Gift,
        IconScale = 1.65,
    }
end

return TimedRewardsWindow
