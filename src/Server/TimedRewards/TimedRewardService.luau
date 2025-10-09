local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Server = ServerScriptService.Server

local Fusion = require(Packages.Fusion)
type Scope = Fusion.Scope<typeof(Fusion)>

local NetworkServer = require(ServerScriptService.NetworkServer)

local PlayerService = require(Server.Player.PlayerService)
type PlayerService = PlayerService.PlayerService

local Terminate = require(Common.Player.Terminate)
local ApplyReward = require(Common.Rewards.ApplyReward)
local TimedRewards = require(Common.TimedRewards.TimedRewards)

export type Services = {
    PlayerService: PlayerService,
}

export type TimedRewardService = {
    Start: () -> ()
}

local function TimedRewardService(scope: Scope, services: Services): TimedRewardService
    local function Start()
        NetworkServer.TimedRewards.ClaimReward.On(function(player: Player, rewardIndex: number, instant: number): ()
            local serverPlayer = services.PlayerService.Get(player)

            if not serverPlayer then
                return Terminate(player, "[TimedRewardService] Player not found")
            end

            if not serverPlayer.TimedRewards.CanClaim(rewardIndex, instant) then
                return Terminate(player, "[TimedRewardService] Player tried to claim an invalid timed reward")
            end

            serverPlayer.TimedRewards.PerformClaim(rewardIndex)
            ApplyReward(serverPlayer, TimedRewards[rewardIndex].Reward :: TimedRewards.TimedReward)

            return
        end)
    end

    local self: TimedRewardService = {
        Start = Start,
    }

    return self
end

return TimedRewardService