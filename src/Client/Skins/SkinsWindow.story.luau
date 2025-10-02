local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)

local SkinsWindow = require(Client.Skins.SkinsWindow)

return function(target: Instance)
    local scope = Fusion.scoped(Fusion)

    local window = SkinsWindow {
        Scope = scope,
    }

    window.Parent = target

    return function()
        scope:doCleanup()
    end
end
