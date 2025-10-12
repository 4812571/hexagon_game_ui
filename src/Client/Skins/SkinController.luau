--!strict
--!native

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)
type Scope = Fusion.Scope<typeof(Fusion)>

local Skins = require(Common.Skins.Skins)
type SkinInfo = Skins.SkinInfo

local NetworkClient = require(ReplicatedStorage.NetworkClient)

local ClientPlayer = require(Client.Player.ClientPlayer)
type ClientPlayer = ClientPlayer.ClientPlayer

export type SkinController = {
    TryPurchase: (skinId: string) -> boolean,
    TryEquip: (skinId: string?) -> boolean,
}

local function SkinController(scope: Scope, player: ClientPlayer)
    local function TryPurchase(skinId: string): boolean
        local skinInfo: SkinInfo = Skins[skinId]

        if not skinInfo then
            warn("SkinController: TryPurchase - Invalid skin ID:", skinId)
            return false
        end

        if player.Skins.HasSkin(skinId) then
            return false
        end

        if not player.Coins.ConsumeCoins(skinInfo.Price) then
            return false
        end
        
        player.Skins.AddSkin(skinId)
        NetworkClient.Skins.PurchaseSkin.Invoke(skinId)

        return true
    end

    local function TryEquip(skinId: string?): boolean
        if skinId and not player.Skins.HasSkin(skinId) then
            return false
        end

        player.Skins.ActiveSkinId:set(skinId)
        NetworkClient.Skins.EquipSkin.Invoke(skinId)
        return true
    end

    local self: SkinController = {
        TryPurchase = TryPurchase,
        TryEquip = TryEquip,
    }

    return self
end

return SkinController
