local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage.Common

local BombsData = require(Common.Bombs.BombsData)
local CoinsData = require(Common.Coins.CoinsData)
local LevelData = require(Common.Level.LevelData)
local OptionsData = require(Common.Options.OptionsData)
local QuestsData = require(Common.Quests.QuestsData)
local TrailsData = require(Common.Trails.TrailsData)
local SpeedData = require(Common.Speed.SpeedData)

export type PlayerData = {
    Bombs: BombsData.BombsData,
    Coins: CoinsData.CoinsData,
    Level: LevelData.LevelData,
    Options: OptionsData.OptionsData,
    Quests: QuestsData.QuestsData,
    Trails: TrailsData.TrailsData,
    Speed: SpeedData.SpeedData,
}

return nil