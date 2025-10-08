local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common

local Fusion = require(Packages.Fusion)
local peek = Fusion.peek
type Scope = Fusion.Scope<typeof(Fusion)>
type Value<T> = Fusion.Value<T>
type UsedAs<T> = Fusion.UsedAs<T>

local GetLevelInfo = require(Common.Level.GetLevelInfo)

local LevelData = require(Common.Level.LevelData)
type LevelData = LevelData.LevelData

export type PlayerLevel = {
    TotalExperience: Value<number>,

    Level: UsedAs<number>,
    Experience: UsedAs<number>,
    RequiredExperience: UsedAs<number>,
}

local function PlayerLevel(scope: Scope, data: LevelData): PlayerLevel
    local totalExperience = scope:Value(data.TotalExperience)

    if RunService:IsServer() then
        scope:Observer(totalExperience):onChange(function()
            data.TotalExperience = peek(totalExperience)
        end)
    end

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

return PlayerLevel
