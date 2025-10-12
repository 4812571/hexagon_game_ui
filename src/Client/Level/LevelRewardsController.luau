--!strict
--!native

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)
local peek = Fusion.peek
type Scope = Fusion.Scope<typeof(Fusion)>

local ApplyReward = require(Common.Rewards.ApplyReward)
local LevelRewards = require(Common.Level.LevelRewards)

local ClientPlayer = require(Client.Player.ClientPlayer)
type ClientPlayer = ClientPlayer.ClientPlayer

export type LevelRewardsController = {
    TryClaim: (rewardIndex: number) -> boolean,    
}

local function LevelRewardsController(scope: Scope, player: ClientPlayer): LevelRewardsController
    local function TryClaim(rewardIndex: number): boolean
        if peek(player.Level.Level) < rewardIndex then
            return false
        end

        if player.LevelRewards.IsClaimed(rewardIndex) then
            return false
        end

        local reward = LevelRewards[rewardIndex]

        if not reward then
            return false
        end

        player.LevelRewards.Claim(rewardIndex)
        ApplyReward(player, reward :: LevelRewards.LevelReward)
        return true
    end

    local self: LevelRewardsController = {
        TryClaim = TryClaim,
    }

    return self
end

return LevelRewardsController
