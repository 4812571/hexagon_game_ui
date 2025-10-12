--!strict
--!native
--!nolint LocalShadow

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages

local Fusion = require(Packages.Fusion)

local CloseButton = require(script.Parent.CloseButton)

return function(target: Instance)
    local scope = Fusion.scoped(Fusion, {
        CloseButton = CloseButton,
    })

    local button = scope:CloseButton {
        Size = UDim2.fromOffset(120, 120),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),

        Activated = function()
            print("Close button activated")
        end,
    }

    button.Parent = target

    return function()
        scope:doCleanup()
    end
end
