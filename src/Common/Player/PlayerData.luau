local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage.Common

local BombsData = require(Common.Bombs.BombsData)
local CoinsData = require(Common.Coins.CoinsData)
local LevelData = require(Common.Level.LevelData)
local LevelRewardsData = require(Common.Level.LevelRewardsData)
local OptionsData = require(Common.Options.OptionsData)
local QuestsData = require(Common.Quests.QuestsData)
local TrailsData = require(Common.Trails.TrailsData)

export type PlayerData = {
    Bombs: BombsData.BombsData,
    Coins: CoinsData.CoinsData,
    Level: LevelData.LevelData,
    LevelRewards: LevelRewardsData.LevelRewardsData,
    Options: OptionsData.OptionsData,
    Quests: QuestsData.QuestsData,
    Trails: TrailsData.TrailsData,
}

return nil
