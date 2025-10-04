local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage.Common

local BombsData = require(Common.Bombs.BombsData)
type BombsData = BombsData.BombsData

local DefaultBombsData: BombsData = {
    Bombs = 3,
    GoldBombs = 0,
    Nukes = 0,
}

return DefaultBombsData