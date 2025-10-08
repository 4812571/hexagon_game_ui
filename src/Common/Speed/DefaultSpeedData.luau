local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage.Common

local SpeedData = require(Common.Speed.SpeedData)
type SpeedData = SpeedData.SpeedData

local DefaultSpeedData: SpeedData = {
    LevelSpeedMultiplier = 1,
    RebirthSpeedMultiplier = 1,
}

return DefaultSpeedData
