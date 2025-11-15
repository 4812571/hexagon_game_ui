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

local Duration = require(Common.Duration)

local DailyRewardsData = require(Common.DailyRewards.DailyRewardsData)
type DailyRewardsData = DailyRewardsData.DailyRewardsData

export type PlayerDailyRewards = {
    LastClaim: Value<number>,
    NextClaimIndex: Value<number>,

    CanClaim: (instant: number) -> boolean,
    PerformClaim: (currentTime: number, totalRewards: number) -> number,
}

local function NextIndex(currentIndex: number, indexCount: number): number
    return (currentIndex % indexCount) + 1
end

local function PlayerDailyRewards(scope: Scope, data: DailyRewardsData): PlayerDailyRewards
    local lastClaim = scope:Value(data.LastClaim)
    local nextClaimIndex = scope:Value(data.NextClaimIndex)

    if RunService:IsServer() then
        scope:Observer(lastClaim):onChange(function()
            data.LastClaim = peek(lastClaim)
        end)

        scope:Observer(nextClaimIndex):onChange(function()
            data.NextClaimIndex = peek(nextClaimIndex)
        end)
    end

    local function GetDay(instant: number): number
        return instant // Duration.Day
    end

    local function CanClaim(instant: number): boolean
        return peek(lastClaim) < GetDay(instant)
    end

    local function PerformClaim(currentTime: number, totalRewards: number)
        local toClaim = peek(nextClaimIndex)
        nextClaimIndex:set(NextIndex(toClaim, totalRewards))

        lastClaim:set(currentTime)
        
        return toClaim
    end

    local self: PlayerDailyRewards = {
        LastClaim = lastClaim,
        NextClaimIndex = nextClaimIndex,

        CanClaim = CanClaim,
        PerformClaim = PerformClaim,
    }

    return self
end

return PlayerDailyRewards
