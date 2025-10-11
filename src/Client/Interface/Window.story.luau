--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common

local Fusion = require(Packages.Fusion)

local Icons = require(Common.Icons)

local Window = require(script.Parent.Window)

return function(target: Instance)
    local scope = Fusion.scoped(Fusion, {
        Window = Window,
    })
    
    local scale = scope:Value(1)

    local instance = scope:Window {
        Title = "Level",
        Icon = Icons.UpArrow,
        IconScale = 1,
        WindowScale = scope:Spring(scale, 20),

        OnClose = function()
            scale:set(0)

            task.delay(2, function()
                scale:set(1)
            end)
        end,
    }

    instance.Parent = target

    return function()
        scope:doCleanup()
    end
end