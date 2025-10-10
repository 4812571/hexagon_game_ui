local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common

local Fusion = require(Packages.Fusion)
local peek = Fusion.peek
type Value<T> = Fusion.Value<T>

local RebirthConfig = require(Common.Rebirth.RebirthConfig)

local CommonPlayer = require(Common.Player.CommonPlayer)
type CommonPlayer = CommonPlayer.CommonPlayer

local function Add(value: Value<number>, amount: number)
    value:set(peek(value) + amount)
end

local function Percent(n: number): number
    return n * 0.01
end

local function ApplyRebirth(player: CommonPlayer)
    player.Coins.Rebirth()
    player.Level.Rebirth()
    player.LevelRewards.Rebirth()

    Add(player.Bombs.Bombs, RebirthConfig.Rewards.Bombs.Bombs)
    Add(player.Bombs.GoldBombs, RebirthConfig.Rewards.Bombs.GoldBombs)
    Add(player.Bombs.Nukes, RebirthConfig.Rewards.Bombs.Nukes)

    Add(player.Coins.IncomeMultiplier, Percent(RebirthConfig.Rewards.IncomePercent))
    Add(player.Speed.RebirthSpeedMultiplier, Percent(RebirthConfig.Rewards.SpeedPercent))
end

return ApplyRebirth