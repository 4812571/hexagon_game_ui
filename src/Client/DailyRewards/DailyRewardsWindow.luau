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

local DailyRewards = require(Common.DailyRewards.DailyRewards)
type DailyReward = DailyRewards.DailyReward

local Window = require(Client.Interface.Window)

export type ClaimState = "NotAvailable" | "Available" | "Claimed"

export type DailyRewardEntry = {
    Day: number,
    Reward: DailyReward,
    ClaimState: Fusion.UsedAs<ClaimState>,
}

export type DailyRewardsWindowProps = {
    Rewards: Fusion.UsedAs<{DailyRewardEntry}>,
    OnClaim: (day: number) -> (),
}

local function DailyRewardsWindow<U>(scope: Scope<U>, props: DailyRewardsWindowProps)
    local scope = scope:innerScope {
        Window = Window,
    }
    
    return scope:Window {
        Title = "Daily",
        Icon = Icons.Calendar,
        IconScale = 1.25,
    }
end

return DailyRewardsWindow
