export type QuestEntry = {
    Completed: boolean,
    Progress: number,
}

export type QuestsData = {
    Quests: {[string]: QuestEntry},
}

return nil