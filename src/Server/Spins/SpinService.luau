--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Server = ServerScriptService.Server

local Fusion = require(Packages.Fusion)
local peek = Fusion.peek
type Scope = Fusion.Scope<typeof(Fusion)>
type Value<T> = Fusion.Value<T>

local NetworkServer = require(ServerScriptService.NetworkServer)

local PlayerService = require(Server.Player.PlayerService)

local SpinRewards = require(Common.Spins.SpinRewards)
local WeightedChoice = require(Common.Util.WeightedChoice)

type Services = {
    PlayerService: PlayerService.PlayerService,
}

type SpinService = {
    Start: () -> (),
}

local function KickAndError(player: Player, message: string): never
    player:Kick(message)
    error(message)
end

local function SpinService(scope: Scope, services: Services): SpinService
    local PlayerService = services.PlayerService
    
    local random = Random.new()
    
    local function Start()
        NetworkServer.Spins.PerformSpin.On(function(player: Player)
            local serverPlayer = PlayerService.Get(player)

            if not serverPlayer then
                return KickAndError(player, "[SpinService] Player data not found")
            end

            if peek(serverPlayer.Spins.Spins) <= 0 then
                return KickAndError(player, "[SpinService] Player has no spins left")
            end

            serverPlayer.Spins.Spins:set(peek(serverPlayer.Spins.Spins) - 1)

            local spinResult = WeightedChoice(random, SpinRewards)
            serverPlayer.Spins.PendingReward:set(spinResult)

            return spinResult
        end)
    end

    local self: SpinService = {
        Start = Start,
    }

    return self
end

return SpinService
