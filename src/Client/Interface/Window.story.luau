local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)

local Icons = require(Common.Icons)

local Window = require(Client.Interface.Window)

return function(target: Instance)
    local scope = Fusion.scoped(Fusion)

    local window = Window {
        Scope = scope,
        Title = "Rebirth",
        Icon = Icons.Rebirth,
    }

    window.Parent = target

    return function()
        scope:doCleanup()
    end
end