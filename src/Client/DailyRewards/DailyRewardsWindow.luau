local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)

local Icons = require(Common.Icons)

local DailyRewards = require(Common.DailyRewards)
type DailyReward = DailyRewards.DailyReward

local Window = require(Client.Interface.Window)

export type ClaimState = "NotAvailable" | "Available" | "Claimed"

export type DailyRewardEntry = {
    Day: number,
    Reward: DailyReward,
    ClaimState: Fusion.UsedAs<ClaimState>,
}

export type DailyRewardsWindowProps = {
    Scope: Fusion.Scope<typeof(Fusion)>,

    Rewards: Fusion.UsedAs<{DailyRewardEntry}>,
    OnClaim: (day: number) -> (),
}

local function DailyRewardsWindow(props: DailyRewardsWindowProps)
    return Window {
        Scope = props.Scope,
        Title = "Daily",
        Icon = Icons.Calendar,
        IconScale = 0.95,
    }
end

return DailyRewardsWindow