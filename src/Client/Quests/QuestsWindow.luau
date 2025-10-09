local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)

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
    Scope: Fusion.Scope<typeof(Fusion)>,
    Quests: { QuestEntry },
}

local function QuestsWindow(props: QuestsWindowProps)
    return Window {
        Scope = props.Scope,
        Title = "Quests",
        Icon = Icons.Scroll,
    }
end

return QuestsWindow