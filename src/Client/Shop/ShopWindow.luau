local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)

local Icons = require(Common.Icons)

local Window = require(Client.Interface.Window)

export type ShopWindowProps = {
    Scope: Fusion.Scope<typeof(Fusion)>,
}

local function ShopWindow(props: ShopWindowProps)
    return Window {
        Scope = props.Scope,
        Title = "Shop",
        Icon = Icons.ShoppingCart,
    }
end

return ShopWindow