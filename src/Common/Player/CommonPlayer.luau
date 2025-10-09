local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common

local Fusion = require(Packages.Fusion)
type Scope<T> = Fusion.Scope<T>

local PlayerData = require(Common.Player.PlayerData)
type PlayerData = PlayerData.PlayerData

local PlayerCoins = require(Common.Coins.PlayerCoins)
local PlayerLevel = require(Common.Level.PlayerLevel)
local PlayerLevelRewards = require(Common.Level.PlayerLevelRewards)
local PlayerBombs = require(Common.Bombs.PlayerBombs)
local PlayerSpeed = require(Common.Speed.PlayerSpeed)
local PlayerOptions = require(Common.Options.PlayerOptions)
local PlayerRevives = require(Common.Revives.PlayerRevives)
local PlayerTrails = require(Common.Trails.PlayerTrails)
local PlayerSpins = require(Common.Spins.PlayerSpins)
local PlayerDailyRewards = require(Common.DailyRewards.PlayerDailyRewards)
local PlayerTimedRewards = require(Common.TimedRewards.PlayerTimedRewards)

export type CommonPlayer = {
    Scope: Scope<unknown>,
    
    Player: Player,
    JoinTime: number,

    Coins: PlayerCoins.PlayerCoins,
    Level: PlayerLevel.PlayerLevel,
    LevelRewards: PlayerLevelRewards.PlayerLevelRewards,
    Bombs: PlayerBombs.PlayerBombs,
    Speed: PlayerSpeed.PlayerSpeed,
    Options: PlayerOptions.PlayerOptions,
    Revives: PlayerRevives.PlayerRevives,
    Trails: PlayerTrails.PlayerTrails,
    Spins: PlayerSpins.PlayerSpins,
    DailyRewards: PlayerDailyRewards.PlayerDailyRewards,
    TimedRewards: PlayerTimedRewards.PlayerTimedRewards,
}


local function CommonPlayer(scope: Scope<typeof(Fusion)>, player: Player, joinTime: number, data: PlayerData): CommonPlayer
    local self: CommonPlayer = {
        Scope = scope,

        Player = player,
        JoinTime = joinTime,

        Coins = PlayerCoins(scope, data.Coins),
        Level = PlayerLevel(scope, data.Level),
        LevelRewards = PlayerLevelRewards(scope, data.LevelRewards),
        Bombs = PlayerBombs(scope, data.Bombs),
        Speed = PlayerSpeed(scope, data.Speed),
        Options = PlayerOptions(scope, data.Options),
        Revives = PlayerRevives(scope, data.Revives),
        Trails = PlayerTrails(scope, data.Trails),
        Spins = PlayerSpins(scope, data.Spins),
        DailyRewards = PlayerDailyRewards(scope, data.DailyRewards),
        TimedRewards = PlayerTimedRewards(scope, joinTime),
    }

    return self
end

return CommonPlayer