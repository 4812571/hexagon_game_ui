local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)

local TrailsWindow = require(Client.Trails.TrailsWindow)

return function(target: Instance)
    local scope = Fusion.scoped(Fusion, {
        TrailsWindow = TrailsWindow,
    })

    local window = scope:TrailsWindow {
    }

    window.Parent = target

    return function()
        scope:doCleanup()
    end
end
