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

type TrailId = string

local function cloneOwnedIds(owned: {TrailId}?): {TrailId}
    local cloned: {TrailId} = {}

    if owned then
        for index, trailId in owned do
            cloned[index] = trailId
        end
    end

    return cloned
end

export type PlayerTrails = {
    EquippedId: Value<TrailId?>,
    OwnedIds: Value<{TrailId}>,

    Equip: (trailId: TrailId) -> (),
    Unequip: () -> (),
    Owns: (trailId: TrailId) -> boolean,
    AddOwnedTrail: (trailId: TrailId) -> (),
}

local function PlayerTrails(scope: Scope, data: TrailsData): PlayerTrails
    local equippedId = scope:Value(data.EquippedId)
    local ownedIds = scope:Value(cloneOwnedIds(data.OwnedIds))

    local function updateEquipped()
        if not RunService:IsServer() then
            return
        end

        data.EquippedId = peek(equippedId)
    end

    local function updateOwned()
        if not RunService:IsServer() then
            return
        end

        data.OwnedIds = cloneOwnedIds(peek(ownedIds))
    end

    if RunService:IsServer() then
        updateEquipped()
        updateOwned()

        scope:Observer(equippedId):onChange(updateEquipped)
        scope:Observer(ownedIds):onChange(updateOwned)
    end

    local function Equip(trailId: TrailId)
        equippedId:set(trailId)
        updateEquipped()
    end

    local function Unequip()
        equippedId:set(nil)
        updateEquipped()
    end

    local function Owns(trailId: TrailId): boolean
        for _, ownedId in peek(ownedIds) do
            if ownedId == trailId then
                return true
            end
        end

        return false
    end

    local function AddOwnedTrail(trailId: TrailId)
        if Owns(trailId) then
            return
        end

        local currentOwned = cloneOwnedIds(peek(ownedIds))
        table.insert(currentOwned, trailId)
        ownedIds:set(currentOwned)
        updateOwned()
    end

    local self: PlayerTrails = {
        EquippedId = equippedId,
        OwnedIds = ownedIds,

        Equip = Equip,
        Unequip = Unequip,
        Owns = Owns,
        AddOwnedTrail = AddOwnedTrail,
    }

    return self
end

return PlayerTrails
