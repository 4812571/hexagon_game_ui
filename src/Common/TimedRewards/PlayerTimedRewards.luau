local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common

local Fusion = require(Packages.Fusion)
local peek = Fusion.peek
type Scope = Fusion.Scope<typeof(Fusion)>

local TimedRewards = require(Common.TimedRewards.TimedRewards)
type TimedRewardData = TimedRewards.TimedRewardData

type Set<T> = { [T]: true }

export type PlayerTimedRewards = {
    TryClaim: (currentTime: number, rewardIndex: number) -> boolean,
}

local function PlayerTimedRewards(scope: Scope, joinTime: number): PlayerTimedRewards
    local claimedIndexes = scope:Value({} :: Set<number>)

    local function TryClaim(currentTime: number, rewardIndex: number): boolean
        local reward: TimedRewardData = TimedRewards[rewardIndex]

        if not reward then
            warn("[PlayerTimedRewards] Invalid reward index: " .. tostring(rewardIndex))
            return false
        end

        if peek(claimedIndexes)[rewardIndex] then
            return false
        end

        local durationSinceJoin = currentTime - joinTime

        if durationSinceJoin < reward.Duration then
            return false
        end

        local newClaimedIndexes = peek(claimedIndexes)
        newClaimedIndexes[rewardIndex] = true
        claimedIndexes:set(newClaimedIndexes)

        return true
    end

    local self: PlayerTimedRewards = {
        TryClaim = TryClaim,
    }

    return self
end

return PlayerTimedRewards