local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)

local Icons = require(Common.Icons)

local LevelRewards = require(Common.LevelRewards)
type LevelReward = typeof(LevelRewards)

local Window = require(Client.Interface.Window)

export type ClaimState = "NotAvailable" | "Available" | "Claimed"

export type LevelRewardEntry = {
    Level: number,
    Reward: LevelReward,
    ClaimState: Fusion.UsedAs<ClaimState>,
}

export type LevelWindowProps = {
    Scope: Fusion.Scope<typeof(Fusion)>,

    Level: Fusion.UsedAs<number>,
    Experience: Fusion.UsedAs<number>,
    ExperienceToNextLevel: Fusion.UsedAs<number>,
    Speed: Fusion.UsedAs<number>,
    Rewards: Fusion.UsedAs<{LevelRewardEntry}>,
    
    OnClaim: (level: number) -> (),
}

local function LevelWindow(props: LevelWindowProps)
    return Window {
        Scope = props.Scope,
        Title = "Level Up",
        Icon = Icons.UpArrow,
    }
end

return LevelWindow