local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)

local DailyRewardsWindow = require(Client.DailyRewards.DailyRewardsWindow)

return function(target: Instance)
    local scope = Fusion.scoped(Fusion)

    local window = DailyRewardsWindow {
        Scope = scope,
    }

    window.Parent = target

    return function()
        scope:doCleanup()
    end
end