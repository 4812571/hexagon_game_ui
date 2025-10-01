local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)

local Window = require(Client.Interface.Window)

return function(target: Instance)
    local scope = Fusion.scoped(Fusion)

    local window = Window {
        Scope = scope,
    }

    window.Parent = target

    return function()
        scope:doCleanup()
    end
end