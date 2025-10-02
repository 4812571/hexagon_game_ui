export type LogInQuest = {
    Type: "LogIn",
}

local function LogInQuest(): LogInQuest
    local quest = {
        Type = "LogIn",
    }

    return quest
end

return LogInQuest