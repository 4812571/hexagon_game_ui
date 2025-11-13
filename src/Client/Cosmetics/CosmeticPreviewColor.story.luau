--!strict
--!native

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common

local Fusion = require(Packages.Fusion)

local Icons = require(Common.Icons)

local CosmeticPreview = require(script.Parent.CosmeticPreview)

return function(target: Instance)
    local scope = Fusion.scoped(Fusion, {
        CosmeticPreview = CosmeticPreview,
    })
    
    local instance = scope:CosmeticPreview {
        Size = UDim2.fromOffset(300, 300),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),

        CornerRadius = UDim.new(0.2, 0),
        Stroke = 4,

        Background = {
            Type = "Color",
            Icon = Icons.Bomb,
            Color = Color3.new(1, 0, 0),
        },

        TextSize = 62,
        Title = "Bomb",
    }

    instance.Parent = target

    return function()
        scope:doCleanup()
    end
end