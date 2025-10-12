--!strict
--!native

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage.Common

local PlayerData = require(Common.Player.PlayerData)
type PlayerData = PlayerData.PlayerData

local DefaultBombsData = require(Common.Bombs.DefaultBombsData)
local DefaultCoinsData = require(Common.Coins.DefaultCoinsData)
local DefaultLevelData = require(Common.Level.DefaultLevelData)
local DefaultLevelRewardsData = require(Common.Level.DefaultLevelRewardsData)
local DefaultOptionsData = require(Common.Options.DefaultOptionsData)
local DefaultQuestsData = require(Common.Quests.DefaultQuestsData)
local DefaultRevivesData = require(Common.Revives.DefaultRevivesData)
local DefaultTrailsData = require(Common.Trails.DefaultTrailsData)
local DefaultSpeedData = require(Common.Speed.DefaultSpeedData)
local DefaultSpinsData = require(Common.Spins.DefaultSpinsData)
local DefaultDailyRewardsData = require(Common.DailyRewards.DefaultDailyRewardsData)
local DefaultSkinsData = require(Common.Skins.DefaultSkinsData)

local DefaultPlayerData: PlayerData = {
    Bombs = DefaultBombsData,
    Coins = DefaultCoinsData,
    Level = DefaultLevelData,
    LevelRewards = DefaultLevelRewardsData,
    Options = DefaultOptionsData,
    Quests = DefaultQuestsData,
    Revives = DefaultRevivesData,
    Trails = DefaultTrailsData,
    Speed = DefaultSpeedData,
    Spins = DefaultSpinsData,
    DailyRewards = DefaultDailyRewardsData,
    Skins = DefaultSkinsData,
}

return DefaultPlayerData
