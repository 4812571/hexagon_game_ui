local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)

local EliminationQuest = require(Common.Quests.Quests.EliminationQuest)
local PlayTimeQuest = require(Common.Quests.Quests.PlayTimeQuest)

local QuestsWindow = require(Client.Quests.QuestsWindow)
type QuestEntry = QuestsWindow.QuestEntry

return function(target: Instance)
    local scope = Fusion.scoped(Fusion)

    local elimination = {
        Quest = EliminationQuest(5),
        QuestId = "elimination_1",
        RewardExperience = 25,
        Progress = 15,
        RequiredProgress = 100,
    }

    local playTime = {
        Quest = PlayTimeQuest(10),
        QuestId = "playtime_1",
        RewardExperience = 50,
        Progress = 5,
        RequiredProgress = 10,
    }

    local window = QuestsWindow {
        Scope = scope,
        Quests = { elimination, playTime },
        OnClaim = function(questEntry: QuestEntry)
            print(`Claimed quest {questEntry.QuestId}`)
        end,
    }

    window.Parent = target

    return function()
        scope:doCleanup()
    end
end
