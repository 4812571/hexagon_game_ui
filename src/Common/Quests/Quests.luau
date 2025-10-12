--!strict
--!native

export type Quest =
    | "PlayTime"
    | "Color"
    | "Elimination"
    | "Win"

export type QuestEntry = {
    Id: string,
    Quest: Quest,
    RequiredProgress: number,
    RewardExperience: number,
}

local function QuestEntry(questId: string, quest: Quest, requiredProgress: number, experiencePerProgress: number): QuestEntry
    local questEntry: QuestEntry = {
        Id = questId,
        Quest = quest,
        RequiredProgress = requiredProgress,
        RewardExperience = requiredProgress * experiencePerProgress,
    }

    return questEntry
end

local Quests = {
    PlayTime1 = QuestEntry("PlayTime1", "PlayTime", 1, 3),
    PlayTime2 = QuestEntry("PlayTime2", "PlayTime", 15, 4),
    PlayTime3 = QuestEntry("PlayTime3", "PlayTime", 60, 5),

    Color1 = QuestEntry("Color1", "Color", 1000, 0.02),
    Color2 = QuestEntry("Color2", "Color", 10000, 0.03),
    Color3 = QuestEntry("Color3", "Color", 100000, 0.04),

    Win1 = QuestEntry("Win1", "Win", 1, 15),
    Win2 = QuestEntry("Win2", "Win", 5, 20),
    Win3 = QuestEntry("Win3", "Win", 30, 30),

    Elimination1 = QuestEntry("Elimination1", "Elimination", 1, 15),
    Elimination2 = QuestEntry("Elimination2", "Elimination", 10, 20),
    Elimination3 = QuestEntry("Elimination3", "Elimination", 50, 30),
}

return Quests
