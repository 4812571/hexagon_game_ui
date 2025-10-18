--!strict
--!native

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages

local Fusion = require(Packages.Fusion)

local LeftSidebarRevives = require(script.Parent.LeftSidebarRevives)

return function(target: Instance)
    local scope = Fusion.scoped(Fusion, {
        LeftSidebarRevives = LeftSidebarRevives,
    })
    
    local instance = scope:LeftSidebarRevives {
        Size = UDim2.fromOffset(0, 32),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Revives = 5,
    }

    instance.Parent = target

    return function()
        scope:doCleanup()
    end
end