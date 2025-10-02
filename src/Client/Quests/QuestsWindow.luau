local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)

local Icons = require(Common.Icons)

local EliminationQuest = require(Common.Quests.EliminationQuest)
local LogInQuest = require(Common.Quests.LogInQuest)
local PlayTimeQuest = require(Common.Quests.PlayTimeQuest)

export type Quest =
    | EliminationQuest.EliminationQuest
    | LogInQuest.LogInQuest
    | PlayTimeQuest.PlayTimeQuest

export type QuestEntry = {
    Quest: Quest,
    QuestId: string,
    RewardExperience: Fusion.UsedAs<number>,
    Completed: Fusion.UsedAs<boolean>,
    Progress: Fusion.UsedAs<number>,
    RequiredProgress: Fusion.UsedAs<number>,
}

local Window = require(Client.Interface.Window)

export type QuestsWindowProps = {
    Scope: Fusion.Scope<typeof(Fusion)>,

    RepeatableQuests: Fusion.UsedAs<{QuestEntry}>,
    DailyQuests: Fusion.UsedAs<{QuestEntry}>,
    WeeklyQuests: Fusion.UsedAs<{QuestEntry}>,

    OnClaim: (QuestEntry) -> (),
}

local function QuestsWindow(props: QuestsWindowProps)
    return Window {
        Scope = props.Scope,
        Title = "Quests",
        Icon = Icons.Scroll,
    }
end

return QuestsWindow