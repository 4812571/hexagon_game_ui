--!strict
--!native

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common

local Fusion = require(Packages.Fusion)

local Icons = require(Common.Icons)

local RebirthRewardCard = require(script.Parent.RebirthRewardCard)

return function(target: Instance)
    local scope = Fusion.scoped(Fusion, {
        RebirthRewardCard = RebirthRewardCard,
    })
    
    local instance = scope:RebirthRewardCard {
        Size = UDim2.fromOffset(120, 120),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),

        Icon = Icons.Bomb,
        TopText = "Bomb",
        BottomText = "+6",
        Color = Color3.fromRGB(140, 105, 246),

        IncomeGain = 10,
    }

    instance.Parent = target

    return function()
        scope:doCleanup()
    end
end