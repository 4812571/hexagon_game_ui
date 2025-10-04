local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common

local Fusion = require(Packages.Fusion)
type Scope = Fusion.Scope<typeof(Fusion)>
type Value<T> = Fusion.Value<T>

local CoinsData = require(Common.Coins.CoinsData)
type CoinsData = CoinsData.CoinsData

export type ClientCoins = {
    Coins: Value<number>,
}

local function ClientCoins(scope: Scope, coinsData: CoinsData): ClientCoins
    local coins = scope:Value(coinsData.Coins)

    local self = {
        Coins = coins,
    }

    return self
end

return ClientCoins