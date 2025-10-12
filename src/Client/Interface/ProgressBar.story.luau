--!strict
--!native

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common

local Fusion = require(Packages.Fusion)
local peek = Fusion.peek

local Clock = require(Common.Util.Clock)

local ProgressBar = require(script.Parent.ProgressBar)

return function(target: Instance)
    local scope = Fusion.scoped(Fusion, {
        ProgressBar = ProgressBar,
    })

    local now = Clock(scope)
    local start = peek(now)

    local passed = scope:Computed(function(use)
        return (use(now) :: number) - start
    end)

    local alpha = scope:Computed(function(use)
        return 1 - (1/(use(passed)/10 + 1))
    end)
    
    local instance = scope:ProgressBar {
        Size = UDim2.fromOffset(300, 50),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),

        BackgroundColor = Color3.new(1, 1, 1),
        BarColor = Color3.fromRGB(53, 255, 3),

        BarAlpha = alpha,
        Text = "Development in progress...",
    }

    instance.Parent = target

    return function()
        scope:doCleanup()
    end
end