--!strict
--!native

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage.Common

local LevelData = require(Common.Level.LevelData)
type LevelData = LevelData.LevelData

local DefaultLevelData: LevelData = {
    TotalExperience = 0,
}

return DefaultLevelData
