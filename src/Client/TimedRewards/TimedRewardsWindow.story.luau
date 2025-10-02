local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)

local TimedRewardsWindow = require(Client.TimedRewards.TimedRewardsWindow)

return function(target: Instance)
    local scope = Fusion.scoped(Fusion)

    local window = TimedRewardsWindow {
        Scope = scope,
    }

    window.Parent = target

    return function()
        scope:doCleanup()
    end
end
