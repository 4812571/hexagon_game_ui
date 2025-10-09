local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Server = ServerScriptService.Server

local Fusion = require(Packages.Fusion)
type Scope = Fusion.Scope<typeof(Fusion)>

local Terminate = require(Common.Player.Terminate)
local ApplyReward = require(ReplicatedStorage.Common.Rewards.ApplyReward)
local DailyRewards = require(ReplicatedStorage.Common.DailyRewards.DailyRewards)

local NetworkServer = require(ServerScriptService.NetworkServer)

local PlayerService = require(Server.Player.PlayerService)
local AuthoritativeTimingService = require(Server.AuthoritativeTimingService)

export type Services = {
    PlayerService: PlayerService.PlayerService,
    AuthoritativeTimingService: AuthoritativeTimingService.AuthoritativeTimingService,
}

export type DailyRewardsService = {
    Start: () -> (),
}

local function DailyRewardsService(scope: Scope, services: Services): DailyRewardsService
    local PlayerService = services.PlayerService
    local AuthoritativeTimingService = services.AuthoritativeTimingService

    local function Start()
        NetworkServer.DailyRewards.ClaimReward.On(function(player: Player, instant: number): ()
            local serverPlayer = PlayerService.Get(player)

            if not serverPlayer then
                return Terminate(player, "[DailyRewardsService] Player not found")
            end

            if not AuthoritativeTimingService.Register(player, instant) then
                return Terminate(player, "[DailyRewardsService] Invalid instant")
            end

            if not serverPlayer.DailyRewards.CanClaim(instant) then
                return Terminate(player, "[DailyRewardsService] Player cannot claim reward")
            end

            local claimIndex = serverPlayer.DailyRewards.PerformClaim(instant, #DailyRewards)
            ApplyReward(serverPlayer, DailyRewards[claimIndex] :: DailyRewards.DailyReward)

            return
        end)
    end

    local self: DailyRewardsService = {
        Start = Start,
    }

    return self
end

return DailyRewardsService