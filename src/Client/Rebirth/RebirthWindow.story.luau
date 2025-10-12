--!strict
--!native

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)

local RebirthWindow = require(Client.Rebirth.RebirthWindow)

return function(target: Instance)
    local scope = Fusion.scoped(Fusion, {
        RebirthWindow = RebirthWindow,
    })

    local window = scope:RebirthWindow {

        SpeedGain = 0.25,
        IncomeGain = 0.2,

        BombGain = 8,
        GoldBombGain = 6,
        NukeGain = 2,

        Level = 15,
        RequiredLevel = 100,

        Coins = 95_281,
        RequiredCoins = 1_000_000,
    }

    window.Parent = target

    return function()
        scope:doCleanup()
    end
end
