local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)

local EliminationQuest = require(Common.Quests.EliminationQuest)
local LogInQuest = require(Common.Quests.LogInQuest)
local PlayTimeQuest = require(Common.Quests.PlayTimeQuest)

local QuestsWindow = require(Client.Quests.QuestsWindow)
type QuestEntry = QuestsWindow.QuestEntry

local function ExampleQuests()
    local elimination1: QuestEntry = {
        Quest = EliminationQuest(1),
        QuestId = "Elimination1",
        Progress = 12,
        RequiredProgress = 1,
        RewardExperience = 100,
        Completed = false,
    }

    local elimination2: QuestEntry = {
        Quest = EliminationQuest(2),
        QuestId = "Elimination2",
        Progress = 3,
        RequiredProgress = 5,
        RewardExperience = 250,
        Completed = false,
    }

    local login1: QuestEntry = {
        Quest = LogInQuest(),
        QuestId = "LogIn1",
        Progress = 1,
        RequiredProgress = 1,
        RewardExperience = 50,
        Completed = false,
    }

    local login2: QuestEntry = {
        Quest = LogInQuest(),
        QuestId = "LogIn2",
        Progress = 0,
        RequiredProgress = 1,
        RewardExperience = 100,
        Completed = true,
    }

    local playTime1: QuestEntry = {
        Quest = PlayTimeQuest(10),
        QuestId = "PlayTime1",
        Progress = 4,
        RequiredProgress = 10,
        RewardExperience = 150,
        Completed = false,
    }

    local playTime2: QuestEntry = {
        Quest = PlayTimeQuest(60),
        QuestId = "PlayTime2",
        Progress = 60,
        RequiredProgress = 60,
        RewardExperience = 500,
        Completed = true,
    }

    local quests = {
        Elimination1 = elimination1,
        Elimination2 = elimination2,
        LogIn1 = login1,
        LogIn2 = login2,
        PlayTime1 = playTime1,
        PlayTime2 = playTime2,
    }

    return quests
end

return function(target: Instance)
    local scope = Fusion.scoped(Fusion)

    local quests = ExampleQuests()

    local repeatableQuests = {
        quests.Elimination1,
        quests.PlayTime1,
    }

    local dailyQuests = {
        quests.LogIn1,
        quests.Elimination2,
    }

    local weeklyQuests = {
        quests.LogIn2,
        quests.PlayTime2,
    }

    local window = QuestsWindow {
        Scope = scope,
    
        RepeatableQuests = repeatableQuests,
        DailyQuests = dailyQuests,
        WeeklyQuests = weeklyQuests,

        OnClaim = function(questEntry: QuestEntry)
            print(`Claimed quest {questEntry.QuestId}`)
        end,
    }

    window.Parent = target

    return function()
        scope:doCleanup()
    end
end
