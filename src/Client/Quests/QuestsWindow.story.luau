--!strict
--!native

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)

local QuestsWindow = require(Client.Quests.QuestsWindow)
type QuestEntry = QuestsWindow.QuestEntry

return function(target: Instance)
    local scope = Fusion.scoped(Fusion, {
        QuestsWindow = QuestsWindow,
    })

    local elimination = {
        Quest = "Elimination",
        RewardExperience = 25,
        Progress = 15,
        RequiredProgress = 100,

        OnClaim = function()
            print("Claimed elimination quest")
        end,
    }

    local playTime = {
        Quest = "PlayTime",
        RewardExperience = 50,
        Progress = 5,
        RequiredProgress = 10,

        OnClaim = function()
            print("Claimed play time quest")
        end,
    }

    local window = scope:QuestsWindow {
        Quests = { elimination, playTime },
    }

    window.Parent = target

    return function()
        scope:doCleanup()
    end
end
