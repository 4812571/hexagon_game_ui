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

local AuthoritativeTimingService = require(Server.AuthoritativeTimingService)
type AuthoritativeTimingService = AuthoritativeTimingService.AuthoritativeTimingService

local Terminate = require(Common.Player.Terminate)
local ApplyReward = require(Common.Rewards.ApplyReward)
local TimedRewards = require(Common.TimedRewards.TimedRewards)

export type Services = {
    PlayerService: PlayerService,
    AuthoritativeTimingService: AuthoritativeTimingService,
}

export type TimedRewardsService = {
    Start: () -> ()
}

local function TimedRewardsService(scope: Scope, services: Services): TimedRewardsService
    local function Start()
        local PlayerService = services.PlayerService
        local AuthoritativeTimingService = services.AuthoritativeTimingService

        NetworkServer.TimedRewards.ClaimReward.On(function(player: Player, rewardIndex: number, instant: number): ()
            local serverPlayer = PlayerService:GetPlayer(player)

            if not serverPlayer then
                return Terminate(player, "[TimedRewardService] Player not found")
            end

            if not AuthoritativeTimingService.Register(player, instant) then
                return Terminate(player, "[TimedRewardService] Player sent an invalid instant")
            end

            if not serverPlayer.TimedRewards.CanClaim(rewardIndex, instant) then
                return Terminate(player, "[TimedRewardService] Player tried to claim an invalid timed reward")
            end

            serverPlayer.TimedRewards.PerformClaim(rewardIndex)
            ApplyReward(serverPlayer, TimedRewards[rewardIndex].Reward :: TimedRewards.TimedReward)

            return
        end)
    end

    local self: TimedRewardsService = {
        Start = Start,
    }

    return self
end

return TimedRewardsService