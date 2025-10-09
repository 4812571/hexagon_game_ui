local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage.Common

local Quests = require(Common.Quests.Quests)

local ActiveQuests: {Quests.QuestEntry} = {
    -- PlayTime
    Quests.PlayTime1,
    Quests.PlayTime2,
    Quests.PlayTime3,

    -- Color
    Quests.Color1,
    Quests.Color2,
    Quests.Color3,

    -- Elimination
    Quests.Elimination1,
    Quests.Elimination2,
    Quests.Elimination3,
    
    -- Win
    Quests.Win1,
    Quests.Win2,
    Quests.Win3,
}

return ActiveQuests