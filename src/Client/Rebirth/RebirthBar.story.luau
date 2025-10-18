--!strict
--!native


local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common

local Fusion = require(Packages.Fusion)

local Icons = require(Common.Icons)

local RebirthBar = require(script.Parent.RebirthBar)

return function(target: Instance)
    local scope = Fusion.scoped(Fusion, {
        RebirthBar = RebirthBar,
    })
    
    local instance = scope:RebirthBar {
        Size = UDim2.fromOffset(640, 60),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),

        Icon = Icons.UpArrow,
        Text = "Reach Level 100",

        Progress = 45,
        RequiredProgress = 100,
    }

    instance.Parent = target

    return function()
        scope:doCleanup()
    end
end