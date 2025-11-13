--!strict
--!native

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages

local Fusion = require(Packages.Fusion)

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
            Type = "Image",
            Image = "rbxassetid://137136802043840",
        },

        TextSize = 62,
        Title = "USA",
    }

    instance.Parent = target

    return function()
        scope:doCleanup()
    end
end