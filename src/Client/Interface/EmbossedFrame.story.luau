-- Inline “story” that renders a static, unpressable EmbossedButton.
-- Looks like the OG button in its non-pressed state (no hover/press logic).

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage.Packages

local Fusion = require(Packages.Fusion)

type Scope<T> = Fusion.Scope<T>
type UsedAs<T> = Fusion.UsedAs<T>

local EmbossedFrame = require(script.Parent.EmbossedFrame)

return function(target: Instance)
	local scope = Fusion.scoped(Fusion, {
        EmbossedFrame = EmbossedFrame,
    })

    local frame = scope:EmbossedFrame {
        Name = "NewerEmbossedButton",

        Size = UDim2.fromOffset(200, 200),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),

        Color = Color3.fromRGB(100, 100, 255),
        CornerRadius = UDim.new(0, 10),

        StrokeColor = Color3.fromRGB(0, 0, 0),
        StrokeThickness = 5.5,
    }

    frame.Parent = target

    return function()
        scope:doCleanup()
    end
end