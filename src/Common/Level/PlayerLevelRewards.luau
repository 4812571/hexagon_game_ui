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
    IsClaimed: (rewardIndex: number) -> boolean,
    Claim: (rewardIndex: number) -> boolean,
}

local function PlayerLevelRewards(scope: Scope, data: LevelRewardsData): PlayerLevelRewards
    local claimedIndexes = scope:Value(data.ClaimedIndexes or ({} :: BlinkSet<number>))

    if RunService:IsServer() then
        scope:Observer(claimedIndexes):onChange(function()
            data.ClaimedIndexes = peek(claimedIndexes)
        end)
    end

    local function IsClaimed(rewardIndex: number): boolean
        return peek(claimedIndexes)[rewardIndex] == true
    end

    local function Claim(rewardIndex: number): boolean
        if IsClaimed(rewardIndex) then
            return false
        end

        local newClaimedIndexes = peek(claimedIndexes)
        newClaimedIndexes[rewardIndex] = true
        claimedIndexes:set(newClaimedIndexes)

        return true
    end

    local self: PlayerLevelRewards = {
        IsClaimed = IsClaimed,
        Claim = Claim,
    }

    return self
end

return PlayerLevelRewards
