local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)

local TrailsWindow = require(Client.Trails.TrailsWindow)

return function(target: Instance)
    local scope = Fusion.scoped(Fusion)

    local window = TrailsWindow {
        Scope = scope,
    }

    window.Parent = target

    return function()
        scope:doCleanup()
    end
end
