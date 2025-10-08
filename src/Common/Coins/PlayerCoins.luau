local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common

local Fusion = require(Packages.Fusion)
local peek = Fusion.peek
type Scope = Fusion.Scope<typeof(Fusion)>
type Value<T> = Fusion.Value<T>

local CoinsData = require(Common.Coins.CoinsData)
type CoinsData = CoinsData.CoinsData

export type PlayerCoins = {
    Coins: Value<number>,
}

local function PlayerCoins(scope: Scope, data: CoinsData): PlayerCoins
    local coins = scope:Value(data.Coins)

    if RunService:IsServer() then
        scope:Observer(coins):onChange(function()
            data.Coins = peek(coins)
        end)
    end

    local self = {
        Coins = coins,
    }

    return self
end

return PlayerCoins
