local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages

local Fusion = require(Packages.Fusion)

local EmbossedButton = require(script.Parent.EmbossedButton)

return function(target: Instance)
    local scope = Fusion.scoped(Fusion)
    
    local instance = EmbossedButton {
        Scope = scope,

        Size = UDim2.fromScale(0.65, 0.35),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
    }

    instance.Parent = target

    return function()
        scope:doCleanup()
    end
end