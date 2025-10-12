--!strict
--!native

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
    IncomeMultiplier: Value<number>,

    AwardCoins: (amount: number) -> (),
    MultiplyCoins: (factor: number) -> (),
    ConsumeCoins: (amount: number) -> boolean,

    Rebirth: () -> (),
}

local function PlayerCoins(scope: Scope, data: CoinsData): PlayerCoins
    local coins = scope:Value(data.Coins)
    local incomeMultiplier = scope:Value(data.IncomeMultiplier)

    if RunService:IsServer() then
        scope:Observer(coins):onChange(function()
            data.Coins = peek(coins)
        end)

        scope:Observer(incomeMultiplier):onChange(function()
            data.IncomeMultiplier = peek(incomeMultiplier)
        end)
    end

    local function AwardCoins(amount: number)
        coins:set(peek(coins) + amount * peek(incomeMultiplier))
    end

    local function MultiplyCoins(factor: number)
        coins:set(peek(coins) * factor)
    end

    local function ConsumeCoins(amount: number): boolean
        if peek(coins) < amount then
            return false
        end

        coins:set(peek(coins) - amount)
        return true
    end

    local function Rebirth()
        coins:set(0)
    end

    local self = {
        Coins = coins,
        IncomeMultiplier = incomeMultiplier,

        AwardCoins = AwardCoins,
        MultiplyCoins = MultiplyCoins,
        ConsumeCoins = ConsumeCoins,

        Rebirth = Rebirth,
    }

    return self
end

return PlayerCoins
