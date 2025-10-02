export type PlayTimeQuest = {
    Type: "PlayTime",
    Minutes: number,
}

local function PlayTimeQuest(minutes: number): PlayTimeQuest
    local quest = {
        Type = "PlayTime",
        Minutes = minutes,
    }

    return quest
end

return PlayTimeQuest