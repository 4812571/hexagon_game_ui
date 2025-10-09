local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common

local Fusion = require(Packages.Fusion)
local peek = Fusion.peek
type Scope = Fusion.Scope<typeof(Fusion)>
type Value<T> = Fusion.Value<T>

local TimedRewards = require(Common.TimedRewards.TimedRewards)
type TimedRewardData = TimedRewards.TimedRewardData

type Set<T> = { [T]: true }

export type PlayerTimedRewards = {
    CanClaim: (rewardIndex: number, instant: number) -> boolean,
    PerformClaim: (rewardIndex: number) -> (),
}

local function Add<T>(set: Value<Set<T>>, item: T)
    local newSet = peek(set)
    newSet[item] = true
    set:set(newSet)
end

local function PlayerTimedRewards(scope: Scope, joinTime: number): PlayerTimedRewards
    local claimedIndexes = scope:Value({} :: Set<number>)

    local function CanClaim(rewardIndex: number, instant: number): boolean
        local reward = TimedRewards[rewardIndex]

        if not reward then
            return false
        end

        if peek(claimedIndexes)[rewardIndex] then
            return false
        end

        local duration = instant - joinTime

        if duration < reward.Duration then
            return false
        end

        return true
    end

    local function PerformClaim(rewardIndex: number)
        Add(claimedIndexes, rewardIndex)
    end

    local self: PlayerTimedRewards = {
        CanClaim = CanClaim,
        PerformClaim = PerformClaim,
    }

    return self
end

return PlayerTimedRewards