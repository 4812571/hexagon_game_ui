local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Server = ServerScriptService.Server

local Fusion = require(Packages.Fusion)
local peek = Fusion.peek
type Scope = Fusion.Scope<typeof(Fusion)>

local Terminate = require(Common.Player.Terminate)
local ApplyReward = require(ReplicatedStorage.Common.Rewards.ApplyReward)
local LevelRewards = require(ReplicatedStorage.Common.Level.LevelRewards)

local NetworkServer = require(ServerScriptService.NetworkServer)

local PlayerService = require(Server.Player.PlayerService)

export type Services = {
    PlayerService: PlayerService.PlayerService,
}

export type LevelRewardsService = {
    Start: () -> (),
}

local function LevelRewardsService(scope: Scope, services: Services): LevelRewardsService
    local function OnClaimReward(player: Player, rewardIndex: number)
        local serverPlayer = services.PlayerService.Expect(player)

        if peek(serverPlayer.Level.Level) < rewardIndex then
            return Terminate(player, "[LevelRewardsService] Player level too low to claim reward")
        end

        if serverPlayer.LevelRewards.IsClaimed(rewardIndex) then
            return Terminate(player, "[LevelRewardsService] Player tried to claim an already claimed reward")
        end

        local reward = LevelRewards[rewardIndex]

        if not reward then
            return Terminate(player, "[LevelRewardsService] Invalid reward index")
        end

        serverPlayer.LevelRewards.Claim(rewardIndex)
        ApplyReward(serverPlayer, reward :: LevelRewards.LevelReward)

        return
    end

    local function Start()
        NetworkServer.LevelRewards.ClaimReward.On(OnClaimReward)
    end

    local self: LevelRewardsService = {
        Start = Start,
    }

    return self
end

return LevelRewardsService