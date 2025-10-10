local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common

local Fusion = require(Packages.Fusion)

local Icons = require(Common.Icons)

local SidebarSquareButton = require(script.Parent.SidebarSquareButton)

return function(target: Instance)
    local scope = Fusion.scoped(Fusion, {
        SidebarSquareButton = SidebarSquareButton,
    })
    
    local instance = scope:SidebarSquareButton {
        Name = "NewSidebarSquareButton",

        Size = UDim2.fromOffset(200, 200),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),

        Icon = Icons.Rebirth,
        Text = "Rebirth",
        Color = Color3.fromRGB(242, 98, 110),
        IsNew = false,
    }

    instance.Parent = target

    return function()
        scope:doCleanup()
    end
end