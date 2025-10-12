local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)

local ShopWindow = require(Client.Shop.ShopWindow)

return function(target: Instance)
    local scope = Fusion.scoped(Fusion, {
        ShopWindow = ShopWindow,
    })

    local window = scope:ShopWindow {

        OnStarterPackPurchase = function()
            print("Purchasing starter pack...")
        end,

        OnBombsPackPurchase = function()
            print("Purchasing bombs pack...")
        end,

        OnHundredBombsPackPurchase = function()
            print("Purchasing 100 bombs pack...")
        end,

        OnMaxSpeedPurchase = function()
            print("Purchasing max speed...")
        end,

        OnDoubleCashPurchase = function()
            print("Purchasing double cash...")
        end,

        OnDoubleStartTilesPurchase = function()
            print("Purchasing double start tiles...")
        end,

        OnRevivesPurchase = function(tier: number)
            print(`Purchasing revives tier {tier}...`)
        end,

        OnCashPurchase = function(tier: number)
            print(`Purchasing cash tier {tier}...`)
        end,
    }

    window.Parent = target

    return function()
        scope:doCleanup()
    end
end
