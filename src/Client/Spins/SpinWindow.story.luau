--!strict
--!native

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common

local Fusion = require(Packages.Fusion)

local Icons = require(Common.Icons)

local SpinWindow = require(script.Parent.SpinWindow)

local debugItems = {
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

return function(target: Instance)
    local scope = Fusion.scoped(Fusion, {
        SpinWindow = SpinWindow,
    })
    
    local instance = scope:SpinWindow {
        Scale = 1.0,
        Visible = true,
        Items = debugItems,
        RatchetActive = true,
        SpinCount = 187,
    }

    instance.Parent = target

    return function()
        scope:doCleanup()
    end
end