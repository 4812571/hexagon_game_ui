--!strict
--!native
--!nolint LocalShadow

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common

local Fusion = require(Packages.Fusion)

local Icons = require(Common.Icons)

local Topbar = require(script.Parent.Topbar)

return function(target: Instance)
    local scope = Fusion.scoped(Fusion, {
        Topbar = Topbar,
    })

    local bar = scope:Topbar {
        Scale = 1.0,
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),

        LeftBar = {
            Icon = Icons.Globe,
            Text = "1000",
            BounceScale = 1.0,
            OnPurchase = function()
                print("Tiles Purchased")
            end,
        },

        RightBar = {
            Icon = Icons.Coin,
            Text = "50",
            BounceScale = 1.0,
            OnPurchase = function()
                print("Coins Purchased")
            end,
        },

        Text = "👑 Gain 9,976 more tiles to WIN! (0.1% complete)",
    }

    bar.Parent = target

    return function()
        scope:doCleanup()
    end
end