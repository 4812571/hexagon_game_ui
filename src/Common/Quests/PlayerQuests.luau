--!strict
--!native

local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common

local Fusion = require(Packages.Fusion)
local peek = Fusion.peek

type Scope = Fusion.Scope<typeof(Fusion)>
type Value<T> = Fusion.Value<T>
type UsedAs<T> = Fusion.UsedAs<T>

local QuestsData = require(Common.Quests.QuestsData)
type QuestsData = QuestsData.QuestsData

local Quests = require(Common.Quests.Quests)
type QuestEntry = Quests.QuestEntry

type Map<K, V> = { [K]: V }

export type PlayerQuests = {
    Progress: Map<string, Value<number>>,
    ClaimCounts: Map<string, UsedAs<number>>,
    CanClaimAny: UsedAs<boolean>,
}

local function PlayerQuests(scope: Scope, data: QuestsData): PlayerQuests
    local progress: Map<string, Value<number>> = {}

    for questId, questProgress in data.Progress do
        progress[questId] = scope:Value(questProgress)
    end

    if RunService:IsServer() then
        for questId, questProgress in progress do
            scope:Observer(questProgress):onChange(function()
                data.Progress[questId] = peek(questProgress)
            end)
        end
    end

    local claimCounts: Map<string, UsedAs<number>> = {}

    for questId, questProgress in progress do
        local entry = Quests[questId] :: QuestEntry?

        if not entry then
            warn("[PlayerQuests] Invalid quest id in progress: " .. questId)
            continue
        end

        claimCounts[questId] = scope:Computed(function(use)
            return use(questProgress) // entry.RequiredProgress
        end)
    end

    -- Optimization to prevent O(n) recheck unless necessary
    local canClaimStates: Map<string, UsedAs<boolean>> = {}

    for questId, claimCount in claimCounts do
        canClaimStates[questId] = scope:Computed(function(use)
            return use(claimCount) > 0
        end)
    end

    local canClaimAny: UsedAs<boolean> = scope:Computed(function(use)
        for _, canClaim in canClaimStates do
            if use(canClaim) then
                return true
            end
        end

        return false
    end)


    local self: PlayerQuests = {
        Progress = progress,
        ClaimCounts = claimCounts,
        CanClaimAny = canClaimAny,
    }

    return self
end

return PlayerQuests
