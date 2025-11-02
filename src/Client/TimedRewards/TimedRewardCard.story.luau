--!strict
--!native

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common

local Fusion = require(Packages.Fusion)

local Icons = require(Common.Icons)

local TimedRewardCard = require(script.Parent.TimedRewardCard)

return function(target: Instance)
    local scope = Fusion.scoped(Fusion, {
        TimedRewardCard = TimedRewardCard,
    })
    
    local instance = scope:TimedRewardCard {
        Size = UDim2.fromOffset(140, 140),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),

        Icon = Icons.Coin,
        Color = Color3.fromRGB(96, 101, 244),
        TopText = "+5000",
        BottomText = "22:48",
        
        CornerRadius = UDim.new(0.16, 0),
        Stroke = 3.0,
    }

    instance.Parent = target

    return function()
        scope:doCleanup()
    end
end