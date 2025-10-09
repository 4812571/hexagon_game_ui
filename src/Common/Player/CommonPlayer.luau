local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage.Common

local PlayerCoins = require(Common.Coins.PlayerCoins)
local PlayerLevel = require(Common.Level.PlayerLevel)
local PlayerLevelRewards = require(Common.Level.PlayerLevelRewards)
local PlayerBombs = require(Common.Bombs.PlayerBombs)
local PlayerOptions = require(Common.Options.PlayerOptions)
local PlayerRevives = require(Common.Revives.PlayerRevives)
local PlayerTrails = require(Common.Trails.PlayerTrails)
local PlayerSpins = require(Common.Spins.PlayerSpins)
local PlayerDailyRewards = require(Common.DailyRewards.PlayerDailyRewards)

type PlayerCoins = PlayerCoins.PlayerCoins
type PlayerLevel = PlayerLevel.PlayerLevel
type PlayerLevelRewards = PlayerLevelRewards.PlayerLevelRewards
type PlayerBombs = PlayerBombs.PlayerBombs
type PlayerOptions = PlayerOptions.PlayerOptions
type PlayerRevives = PlayerRevives.PlayerRevives
type PlayerTrails = PlayerTrails.PlayerTrails
type PlayerSpins = PlayerSpins.PlayerSpins
type PlayerDailyRewards = PlayerDailyRewards.PlayerDailyRewards

export type CommonPlayer = {
    Coins: PlayerCoins,
    Level: PlayerLevel,
    LevelRewards: PlayerLevelRewards,
    Bombs: PlayerBombs,
    Revives: PlayerRevives,
    Options: PlayerOptions,
    Trails: PlayerTrails,
    Spins: PlayerSpins,
}

return nil