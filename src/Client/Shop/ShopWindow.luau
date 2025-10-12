--!strict
--!nolint LocalShadow

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)

type Scope<T> = Fusion.Scope<typeof(Fusion) & T>

local Icons = require(Common.Icons)

local Window = require(Client.Interface.Window)

export type ShopWindowProps = {
    OnStarterPackPurchase: () -> (),
    OnBombsPackPurchase: () -> (),
    OnHundredBombsPackPurchase: () -> (),

    OnMaxSpeedPurchase: () -> (),
    OnDoubleCashPurchase: () -> (),
    OnDoubleStartTilesPurchase: () -> (),
    
    OnRevivesPurchase: (tier: number) -> (),
    OnCashPurchase: (tier: number) -> (),
}

local function ShopWindow<U>(scope: Scope<U>, props: ShopWindowProps)
    local scope = scope:innerScope {
        Window = Window,
    }

    return scope:Window {
        Title = "Shop",
        Icon = Icons.ShoppingCart,
        IconScale = 1.35,
    }
end

return ShopWindow