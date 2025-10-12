--!strict
--!native

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common

local Fusion = require(Packages.Fusion)
local peek = Fusion.peek
type Scope = Fusion.Scope<typeof(Fusion)>
type Value<T> = Fusion.Value<T>

local RevivesData = require(Common.Revives.RevivesData)
type RevivesData = RevivesData.RevivesData

export type PlayerRevives = {
    Revives: Value<number>,
}

local function PlayerRevives(scope: Scope, data: RevivesData): PlayerRevives
    local revives = scope:Value(data.Revives)

    if RunService:IsServer() then
        scope:Observer(revives):onChange(function()
            data.Revives = peek(revives)
        end)
    end

    local self = {
        Revives = revives,
    }

    return self
end

return PlayerRevives
