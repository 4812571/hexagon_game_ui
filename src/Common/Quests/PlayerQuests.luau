local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common

local Fusion = require(Packages.Fusion)
local peek = Fusion.peek
type Scope = Fusion.Scope<typeof(Fusion)>
type Value<T> = Fusion.Value<T>

local QuestsData = require(Common.Quests.QuestsData)
type QuestsData = QuestsData.QuestsData

type Map<K, V> = { [K]: V }

export type PlayerQuests = {
    Progress: Map<string, Value<number>>,
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

    local self: PlayerQuests = {
        Progress = progress,
    }

    return self
end

return PlayerQuests
