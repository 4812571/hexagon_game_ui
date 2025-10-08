local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common

local Fusion = require(Packages.Fusion)
local peek = Fusion.peek
type Scope = Fusion.Scope<typeof(Fusion)>
type Value<T> = Fusion.Value<T>
type UsedAs<T> = Fusion.UsedAs<T>

local SpeedData = require(Common.Speed.SpeedData)
type SpeedData = SpeedData.SpeedData

local SpeedConfig = require(Common.Speed.SpeedConfig)

export type PlayerSpeed = {
    LevelSpeedMultiplier: Value<number>,
    RebirthSpeedMultiplier: Value<number>,

    SpeedMultiplier: UsedAs<number>,
    Speed: UsedAs<number>,
}

local function PlayerSpeed(scope: Scope, data: SpeedData): PlayerSpeed
    local levelSpeedMultiplier = scope:Value(data.LevelSpeedMultiplier)
    local rebirthSpeedMultiplier = scope:Value(data.RebirthSpeedMultiplier)

    if RunService:IsServer() then
        scope:Observer(levelSpeedMultiplier):onChange(function()
            data.LevelSpeedMultiplier = peek(levelSpeedMultiplier)
        end)

        scope:Observer(rebirthSpeedMultiplier):onChange(function()
            data.RebirthSpeedMultiplier = peek(rebirthSpeedMultiplier)
        end)
    end

    local speedMultiplier = scope:Computed(function(use)
        return use(levelSpeedMultiplier) * use(rebirthSpeedMultiplier)
    end)

    local speed = scope:Computed(function(use)
        return use(speedMultiplier) * SpeedConfig.BaseSpeed
    end)

    local self: PlayerSpeed = {
        LevelSpeedMultiplier = levelSpeedMultiplier,
        RebirthSpeedMultiplier = rebirthSpeedMultiplier,

        SpeedMultiplier = speedMultiplier,
        Speed = speed,
    }

    return self
end

return PlayerSpeed
