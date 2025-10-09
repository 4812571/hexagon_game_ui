local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage.Common

local QuestsData = require(Common.Quests.QuestsData)
type QuestsData = QuestsData.QuestsData

local ActiveQuests = require(Common.Quests.ActiveQuests)

local progress = {}

for _, questEntry in ActiveQuests do
    progress[questEntry.Id] = 0
end

local DefaultQuestsData: QuestsData = {
    Progress = progress,
}

return DefaultQuestsData