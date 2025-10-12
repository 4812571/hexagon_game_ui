--!strict
--!native

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common

local Fusion = require(Packages.Fusion)

local Icons = require(Common.Icons)

local Icon = require(script.Parent.Icon)

return function(target: Instance)
    local scope = Fusion.scoped(Fusion, {
        Icon = Icon,
    })

    local icon = scope:Icon {
        Name = "Icon",

        Size = UDim2.fromOffset(200, 200),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),

        Icon = Icons.Gift,
        IconScale = 1.2,
    }

    icon.Parent = target

    return function()
        scope:doCleanup()
    end
end
