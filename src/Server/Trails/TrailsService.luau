--!strict
--!native

local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Server = ServerScriptService.Server

local Fusion = require(Packages.Fusion)
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

    local function OnPurchase(player: Player, trailId: string): ()
        local serverPlayer = PlayerService.Expect(player)

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

        if not serverPlayer.Coins.ConsumeCoins(trailEntry.Price.Amount) then
            return Terminate(player, "[TrailsService] Not enough coins for trail: " .. trailId)
        end
        
        serverPlayer.Trails.AddTrail(trailId)

        return
    end

    local function OnEquip(player: Player, trailId: string?): ()
        local serverPlayer = PlayerService.Expect(player)

        if trailId and not serverPlayer.Trails.HasTrail(trailId) then
            return Terminate(player, "[TrailsService] Player does not own trail: " .. trailId)
        end

        serverPlayer.Trails.EquippedId:set(trailId)

        return
    end

    local function Start()
        NetworkServer.Trails.PurchaseTrail.On(OnPurchase)
        NetworkServer.Trails.EquipTrail.On(OnEquip)
    end

    local self: TrailsService = {
        Start = Start,
    }

    return self
end

return TrailsService
