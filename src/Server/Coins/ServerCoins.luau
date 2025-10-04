local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common

local Fusion = require(Packages.Fusion)
local peek = Fusion.peek
type Value<T> = Fusion.Value<T>
type Scope = Fusion.Scope<typeof(Fusion)>

local CoinsData = require(Common.Coins.CoinsData)
type CoinsData = CoinsData.CoinsData

export type ServerCoins = {
    Coins: Value<number>,
}

local function ServerCoins(scope: Scope, data: CoinsData)
    local coins = scope:Value(data.Coins)

    scope:Observer(coins):onChange(function()
        data.Coins = peek(coins)
    end)

    local self: ServerCoins = {
        Coins = coins,
    }

    return self
end

return ServerCoins