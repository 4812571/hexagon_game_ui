local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common

local Fusion = require(Packages.Fusion)

local Icons = require(Common.Icons)

local TopbarItem = require(script.Parent.TopbarItem)

return function(target: Instance)
    local scope = Fusion.scoped(Fusion, {
        TopbarItem = TopbarItem,
    })

    local iconPosition = scope:Value(Vector2.new(0, 0))
    
    local instance = scope:TopbarItem {
        Size = UDim2.fromOffset(400, 100),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),

        Icon = Icons.Coin,
        Text = "1.22M",

        IconPositionOut = iconPosition,
    }

    scope:Observer(iconPosition):onBind(function()
        print(`Icon Position: {Fusion.peek(iconPosition)}`)
    end)

    instance.Parent = target

    return function()
        scope:doCleanup()
    end
end