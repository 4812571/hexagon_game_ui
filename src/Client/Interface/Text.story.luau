--!strict
--!native

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages

local Fusion = require(Packages.Fusion)

local Text = require(script.Parent.Text)

return function(target: Instance)
    local scope = Fusion.scoped(Fusion, {
        Text = Text,
    })
    
    local instance = scope:Text {
        Text = "Hello, World!",
        TextSize = 36,
        StrokeSize = 3,
    }

    instance.Parent = target

    return function()
        scope:doCleanup()
    end
end