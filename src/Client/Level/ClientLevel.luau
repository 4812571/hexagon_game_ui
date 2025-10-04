local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages

local Fusion = require(Packages.Fusion)
type Scope = Fusion.Scope<typeof(Fusion)>
type Value<T> = Fusion.Value<T>
type UsedAs<T> = Fusion.UsedAs<T>

local Common = ReplicatedStorage.Common

local GetLevelInfo = require(Common.Level.GetLevelInfo)

local LevelData = require(Common.Level.LevelData)
type LevelData = LevelData.LevelData

export type ClientLevel = {
    TotalExperience: Value<number>,
    
    Level: UsedAs<number>,
    Experience: UsedAs<number>,
    RequiredExperience: UsedAs<number>,
}

local function ClientLevel(scope: Scope, data: LevelData): ClientLevel
    local totalExperience = scope:Value(data.TotalExperience)

    local levelInfo = scope:Computed(function(use)
        return GetLevelInfo(use(totalExperience))
    end)

    local level = scope:Computed(function(use)
        return use(levelInfo).Level
    end)

    local experience = scope:Computed(function(use)
        return use(levelInfo).Experience
    end)

    local requiredExperience = scope:Computed(function(use)
        return use(levelInfo).RequiredExperience
    end)

    local self = {
        TotalExperience = totalExperience,

        Level = level,
        Experience = experience,
        RequiredExperience = requiredExperience,
    }

    return self
end

return ClientLevel