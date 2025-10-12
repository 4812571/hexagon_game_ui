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

local TrailsData = require(Common.Trails.TrailsData)
type TrailsData = TrailsData.TrailsData

export type PlayerTrails = {
    EquippedId: Value<string?>,
    OwnedIds: Value<{string}>,

    HasTrail: (trailId: string) -> boolean,
    AddTrail: (trailId: string) -> (),
}

local function PlayerTrails(scope: Scope, trailsData: TrailsData)
    local equippedId: Value<string?> = scope:Value(trailsData.EquippedId)
    local ownedIds: Value<{[string]: boolean}> = scope:Value(trailsData.OwnedIds)

    if RunService:IsServer() then
        scope:Observer(equippedId):onChange(function()
            equippedId:set(peek(equippedId))
        end)

        scope:Observer(ownedIds):onChange(function()
            ownedIds:set(peek(ownedIds))
        end)
    end

    local function HasTrail(trailId: string): boolean
        return peek(ownedIds)[trailId] == true
    end

    local function AddTrail(trailId: string)
        local currentOwnedIds = peek(ownedIds)
        currentOwnedIds[trailId] = true
        ownedIds:set(currentOwnedIds)
    end

    local self: PlayerTrails = {
        EquippedId = equippedId,
        OwnedIds = ownedIds,

        HasTrail = HasTrail,
        AddTrail = AddTrail,
    }
    
    return self
end

return PlayerTrails
