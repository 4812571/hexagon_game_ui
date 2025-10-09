local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage.Common

local BombsData = require(Common.Bombs.BombsData)
local CoinsData = require(Common.Coins.CoinsData)
local LevelData = require(Common.Level.LevelData)
local LevelRewardsData = require(Common.Level.LevelRewardsData)
local OptionsData = require(Common.Options.OptionsData)
local QuestsData = require(Common.Quests.QuestsData)
local RevivesData = require(Common.Revives.RevivesData)
local TrailsData = require(Common.Trails.TrailsData)
local SpeedData = require(Common.Speed.SpeedData)
local SpinsData = require(Common.Spins.SpinsData)
local DailyRewardsData = require(Common.DailyRewards.DailyRewardsData)

export type PlayerData = {
    Bombs: BombsData.BombsData,
    Coins: CoinsData.CoinsData,
    Level: LevelData.LevelData,
    LevelRewards: LevelRewardsData.LevelRewardsData,
    Options: OptionsData.OptionsData,
    Quests: QuestsData.QuestsData,
    Revives: RevivesData.RevivesData,
    Trails: TrailsData.TrailsData,
    Speed: SpeedData.SpeedData,
    Spins: SpinsData.SpinsData,
    DailyRewards: DailyRewardsData.DailyRewardsData,
}

return nil
