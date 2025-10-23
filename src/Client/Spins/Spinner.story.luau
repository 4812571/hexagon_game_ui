--!strict
--!native
--!nolint LocalShadow

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common

local Fusion = require(Packages.Fusion)

local Icons = require(Common.Icons)

local Spinner = require(script.Parent.Spinner)

return function(target: Instance)
    local scope = Fusion.scoped(Fusion, {
        Stopwatch = require(Common.Util.Stopwatch),
        Spinner = Spinner,
    })

    local debugItems: {Spinner.SpinnerItemProps} = {
        [1] = {
            Icon = Icons.Rocket,
            Text = "NUKE",
            Percentage = 12,
        },

        [2] = {
            Icon = Icons.Heart,
            Text = "+1",
            Percentage = 13,
        },

        [3] = {
            Icon = Icons.Bomb,
            Text = "+3",
            Percentage = 12,
        },

        [4] = {
            Icon = Icons.Coin,
            Text = "+5k",
            Percentage = 13,
        },

        [5] = {
            Icon = Icons.Coin,
            Text = "x5",
            Percentage = 12,
        },

        [6] = {
            Icon = Icons.Spinner,
            Text = "+3",
            Percentage = 13,
        },

        [7] = {
            Icon = Icons.Bomb,
            Text = "+2",
            Percentage = 12,
        },

        [8] = {
            Icon = Icons.Coin,
            Text = "+10k",
            Percentage = 13,
        },
    }
    
    local stopwatch = scope:Stopwatch()

    local rotation = scope:Computed(function(use)
        return (use(stopwatch) :: number) * 12 % 360
    end)

    local instance = scope:Spinner {
        Size = UDim2.fromOffset(500, 500),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),

        Rotation = rotation,
        PercentagesVisible = true,
        Items = debugItems,
    }

    instance.Parent = target

    return function()
        scope:doCleanup()
    end
end