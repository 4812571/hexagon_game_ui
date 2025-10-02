local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)

local QuestsWindow = require(Client.Quests.QuestsWindow)

return function(target: Instance)
    local scope = Fusion.scoped(Fusion)

    local window = QuestsWindow {
        Scope = scope,
    }

    window.Parent = target

    return function()
        scope:doCleanup()
    end
end
