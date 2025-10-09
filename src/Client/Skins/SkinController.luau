local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)
local peek = Fusion.peek
type Scope = Fusion.Scope<typeof(Fusion)>

local Skins = require(Common.Skins.Skins)
type SkinInfo = Skins.SkinInfo

local NetworkClient = require(ReplicatedStorage.NetworkClient)

local ClientPlayer = require(Client.Player.ClientPlayer)
type ClientPlayer = ClientPlayer.ClientPlayer

export type SkinController = {
    TryPurchase: (skinId: string) -> boolean,
}

local function SkinController(scope: Scope, player: ClientPlayer)
    local function TryPurchase(skinId: string): boolean
        local skinInfo: SkinInfo = Skins[skinId]

        if not skinInfo then
            warn("SkinController: TryPurchase - Invalid skin ID:", skinId)
            return false
        end

        if peek(player.Skins.OwnedSkins)[skinId] then
            return false
        end
        
        if peek(player.Coins.Coins) < skinInfo.Price then
            return false
        end

        player.Coins.Coins:set(peek(player.Coins.Coins) - skinInfo.Price)
        player.Skins.AddSkin(skinId)

        NetworkClient.Skins.PurchaseSkin.Invoke(skinId)

        return true
    end

    local self: SkinController = {
        TryPurchase = TryPurchase,
    }

    return self
end

return SkinController