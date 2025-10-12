--!strict
--!native

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Server = ServerScriptService.Server

local Fusion = require(Packages.Fusion)
type Scope = Fusion.Scope<typeof(Fusion)>

local Terminate = require(Common.Player.Terminate)

local Skins = require(Common.Skins.Skins)
type SkinInfo = Skins.SkinInfo

local NetworkServer = require(ServerScriptService.NetworkServer)

local PlayerService = require(Server.Player.PlayerService)

type Services = {
    PlayerService: PlayerService.PlayerService,
}

export type SkinService = {
    Start: () -> (),
}

local function SkinService(scope: Scope, services: Services): SkinService
    local PlayerService = services.PlayerService

    local function OnPurchase(player: Player, skinId: string): ()
        local serverPlayer = PlayerService.Expect(player)
        
        local skinInfo: SkinInfo? = Skins[skinId]

        if not skinInfo then
            return Terminate(player, "[SkinService] PurchaseSkin - Invalid skin ID: " .. skinId)
        end

        if serverPlayer.Skins.HasSkin(skinId) then
            return Terminate(player, "[SkinService] PurchaseSkin - Player already owns skin: " .. skinId)
        end

        if not serverPlayer.Coins.ConsumeCoins(skinInfo.Price) then
            return Terminate(player, "[SkinService] PurchaseSkin - Not enough coins for skin: " .. skinId)
        end

        serverPlayer.Skins.AddSkin(skinId)

        return
    end

    local function OnEquip(player: Player, skinId: string?): ()
        local serverPlayer = PlayerService.Expect(player)

        if skinId and not serverPlayer.Skins.HasSkin(skinId) then
            return Terminate(player, "[SkinService] EquipSkin - Player does not own skin: " .. skinId)
        end

        serverPlayer.Skins.EquippedSkin:set(skinId)

        return
    end

    local function Start()
        NetworkServer.Skins.PurchaseSkin.On(OnPurchase)
        NetworkServer.Skins.EquipSkin.On(OnEquip)
    end

    local self: SkinService = {
        Start = Start,
    }

    return self
end

return SkinService
