local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Server = ServerScriptService.Server

local Fusion = require(Packages.Fusion)
local peek = Fusion.peek
type Scope = Fusion.Scope<typeof(Fusion)>

local Terminate = require(Common.Player.Terminate)
local Trails = require(Common.Trails.Trails)

local NetworkServer = require(ServerScriptService.NetworkServer)

local PlayerService = require(Server.Player.PlayerService)
type PlayerService = PlayerService.PlayerService

export type Services = {
    PlayerService: PlayerService,
}

export type TrailsService = {
    Start: () -> (),
}

local function TrailsService(scope: Scope, services: Services): TrailsService
    local PlayerService = services.PlayerService

    local function Start()
        NetworkServer.Trails.PurchaseTrail.On(function(player: Player, trailId: string): ()
            local serverPlayer = PlayerService.Get(player)
            
            if not serverPlayer then
                return Terminate(player, "[TrailsService] Player not found")
            end

            if serverPlayer.Trails.HasTrail(trailId) then
                return Terminate(player, "[TrailsService] Player already owns trail: " .. trailId)
            end

            local trailEntry: Trails.TrailEntry? = Trails[trailId]

            if not trailEntry then
                return Terminate(player, "[TrailsService] Invalid trail id: " .. trailId)
            end

            if trailEntry.Price.Currency ~= "Coins" then
                return Terminate(player, "[TrailsService] Cannot purchase non-coin trails directly")
            end

            local coins = serverPlayer.Coins.Coins

            if peek(coins) < trailEntry.Price.Amount then
                return Terminate(player, "[TrailsService] Player does not have enough coins to purchase trail: " .. trailId)
            end

            coins:set(peek(coins) - trailEntry.Price.Amount)
            serverPlayer.Trails.AddTrail(trailId)

            return
        end)
    end

    local self: TrailsService = {
        Start = Start,
    }

    return self
end

return TrailsService