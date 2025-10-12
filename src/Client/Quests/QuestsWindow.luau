--!strict
--!nolint LocalShadow

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)

type Scope<T> = Fusion.Scope<typeof(Fusion) & T>

local Icons = require(Common.Icons)

local Quests = require(Common.Quests.Quests)
type Quest = Quests.Quest

export type QuestEntry = {
    Quest: Quest,
    RewardExperience: Fusion.UsedAs<number>,
    Progress: Fusion.UsedAs<number>,
    RequiredProgress: Fusion.UsedAs<number>,

    OnClaim: () -> (),
}

local Window = require(Client.Interface.Window)

export type QuestsWindowProps = {
    Quests: { QuestEntry },
}

local function QuestsWindow<U>(scope: Scope<U>, props: QuestsWindowProps)
    local scope = scope:innerScope {
        Window = Window,
    }

    return scope:Window {
        Title = "Quests",
        Icon = Icons.Scroll,
    }
end

return QuestsWindow