local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage.Common

local QuestsData = require(Common.Quests.QuestsData)
type QuestsData = QuestsData.QuestsData

local DefaultQuestsData: QuestsData = {
    Progress = {},
}

return DefaultQuestsData