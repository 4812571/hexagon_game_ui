local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common

local Fusion = require(Packages.Fusion)
local peek = Fusion.peek
type Scope = Fusion.Scope<typeof(Fusion)>
type Value<T> = Fusion.Value<T>

local Rewards = require(Common.Rewards)
type Reward = Rewards.Reward

local SpinsData = require(Common.Spins.SpinsData)
type SpinsData = SpinsData.SpinsData

export type PlayerSpins = {
    Spins: Value<number>,
    PendingReward: Value<Reward?>,

    PerformSpin: (reward: Reward) -> (),
}

local function PlayerSpins(scope: Scope, initialData: SpinsData): PlayerSpins
    local spins = scope:Value(initialData.Spins)
    local pendingReward = scope:Value(initialData.PendingReward)

    if RunService:IsServer() then
        scope:Observer(spins):onChange(function()
            initialData.Spins = peek(spins)
        end)

        scope:Observer(pendingReward):onChange(function()
            initialData.PendingReward = peek(pendingReward)
        end)
    end

    local function PerformSpin(reward: Reward)
        spins:set(peek(spins) - 1)
        pendingReward:set(reward)
    end

    local self: PlayerSpins = {
        Spins = spins,
        PendingReward = pendingReward,

        PerformSpin = PerformSpin,
    }

    return self
end

return PlayerSpins