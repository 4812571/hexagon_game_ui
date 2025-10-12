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

local LevelRewards = require(Common.Level.LevelRewards)
type LevelReward = typeof(LevelRewards)

local Window = require(Client.Interface.Window)

export type ClaimState = "NotAvailable" | "Available" | "Claimed"

export type LevelRewardEntry = {
    Level: number,
    Reward: LevelReward,
    ClaimState: Fusion.UsedAs<ClaimState>,
}

export type LevelWindowProps = {
    Level: Fusion.UsedAs<number>,
    Experience: Fusion.UsedAs<number>,
    ExperienceToNextLevel: Fusion.UsedAs<number>,
    Speed: Fusion.UsedAs<number>,
    Rewards: Fusion.UsedAs<{LevelRewardEntry}>,

    OnClaim: (level: number) -> (),
}

local function LevelWindow<U>(scope: Scope<U>, props: LevelWindowProps)
    local scope = scope:innerScope {
        Window = Window,
    }

    return scope:Window {
        Title = "Level",
        Icon = Icons.UpArrow,
        IconScale = 1.35,
    }
end

return LevelWindow
