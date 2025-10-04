export type LevelInfo = {
    Level: number,
    Experience: number,
    RequiredExperience: number,
}

local BASE_EXPERIENCE = 100
local EXPERIENCE_PER_LEVEL = 30

local function GetLevelInfo(totalExperience: number): LevelInfo
    local level = 1
    local remainingExperience = totalExperience
    local requiredExperience = BASE_EXPERIENCE

    while remainingExperience >= requiredExperience do
        level += 1
        remainingExperience -= requiredExperience
        requiredExperience += EXPERIENCE_PER_LEVEL
    end

    local levelInfo: LevelInfo = {
        Level = level,
        Experience = remainingExperience,
        RequiredExperience = requiredExperience,
    }

    return levelInfo
end

return GetLevelInfo