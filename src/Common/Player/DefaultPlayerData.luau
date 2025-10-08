local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage.Common

local PlayerData = require(Common.Player.PlayerData)
type PlayerData = PlayerData.PlayerData

local DefaultBombsData = require(Common.Bombs.DefaultBombsData)
local DefaultCoinsData = require(Common.Coins.DefaultCoinsData)
local DefaultLevelData = require(Common.Level.DefaultLevelData)
local DefaultOptionsData = require(Common.Options.DefaultOptionsData)
local DefaultQuestsData = require(Common.Quests.DefaultQuestsData)
local DefaultTrailsData = require(Common.Trails.DefaultTrailsData)
local DefaultSpeedData = require(Common.Speed.DefaultSpeedData)

local DefaultPlayerData: PlayerData = {
    Bombs = DefaultBombsData,
    Coins = DefaultCoinsData,
    Level = DefaultLevelData,
    Options = DefaultOptionsData,
    Quests = DefaultQuestsData,
    Trails = DefaultTrailsData,
    Speed = DefaultSpeedData,
}

return DefaultPlayerData