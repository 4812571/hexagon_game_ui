--!strict
--!native

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common

local Fusion = require(Packages.Fusion)
local peek = Fusion.peek
type Scope = Fusion.Scope<typeof(Fusion)>

local LevelRewardsData = require(Common.Level.LevelRewardsData)
type BlinkSet<T> = LevelRewardsData.BlinkSet<T>
type LevelRewardsData = LevelRewardsData.LevelRewardsData

export type PlayerLevelRewards = {
    ClaimedIndexes: Fusion.UsedAs<BlinkSet<number>>,
    IsClaimed: (rewardIndex: number) -> boolean,
    Claim: (rewardIndex: number) -> (),
    Rebirth: () -> (),
}

local function PlayerLevelRewards(scope: Scope, data: LevelRewardsData): PlayerLevelRewards
    local claimedIndexes = scope:Value(data.ClaimedIndexes)

    if RunService:IsServer() then
        scope:Observer(claimedIndexes):onChange(function()
            data.ClaimedIndexes = peek(claimedIndexes)
        end)
    end

    local function IsClaimed(rewardIndex: number): boolean
        return peek(claimedIndexes)[rewardIndex] == true
    end

    local function Claim(rewardIndex: number)
        local newClaimedIndexes = peek(claimedIndexes)
        newClaimedIndexes[rewardIndex] = true
        claimedIndexes:set(newClaimedIndexes)
    end

    local function Rebirth()
        claimedIndexes:set({})
    end

    local self: PlayerLevelRewards = {
        ClaimedIndexes = claimedIndexes,
        IsClaimed = IsClaimed,
        Claim = Claim,
        Rebirth = Rebirth,
    }

    return self
end

return PlayerLevelRewards
