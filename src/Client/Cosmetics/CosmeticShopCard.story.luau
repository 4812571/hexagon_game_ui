--!strict
--!native

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common

local Fusion = require(Packages.Fusion)

local Icons = require(Common.Icons)

local CosmeticShopCard = require(script.Parent.CosmeticShopCard)

return function(target: Instance)
    local scope = Fusion.scoped(Fusion, {
        CosmeticShopCard = CosmeticShopCard,
    })
    
    local instance = scope:CosmeticShopCard {
        Size = UDim2.fromOffset(300, 300),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),

        CornerRadius = UDim.new(0.2, 0),
        Stroke = 4,

        Icon = Icons.Bomb,
        TextSize = 62,
        Title = "Bomb",

        Color = Color3.new(1, 0, 0),

        CurrencyIcon = Icons.Coin,
        CurrencyText = "500",
        CurrencyTextSize = 52,
    }

    instance.Parent = target

    return function()
        scope:doCleanup()
    end
end