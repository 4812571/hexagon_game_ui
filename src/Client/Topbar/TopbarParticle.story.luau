--!strict
--!native

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common

local Fusion = require(Packages.Fusion)

local Icons = require(Common.Icons)

local TopbarParticle = require(script.Parent.TopbarParticle)

return function(target: Instance)
    local scope = Fusion.scoped(Fusion, {
        TopbarParticle = TopbarParticle,
    })

    local instance = scope:TopbarParticle {
        Icon = Icons.Coin,
        Scale = 1.0,
        Size = UDim2.fromOffset(100, 100),
        Position = UDim2.fromScale(0.5, 0.5),
    }
    
    instance.Parent = target

    return function()
        scope:doCleanup()
    end
end