local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage.Common

local TrailsData = require(Common.Trails.TrailsData)
type TrailsData = TrailsData.TrailsData

local DefaultTrailsData: TrailsData = {
    EquippedId = nil,
    OwnedIds = {},
}

return DefaultTrailsData