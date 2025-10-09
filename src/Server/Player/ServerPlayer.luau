local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common

local Fusion = require(Packages.Fusion)
type UnknownScope = Fusion.Scope<unknown>
type FusionScope = Fusion.Scope<typeof(Fusion)>

local PlayerData = require(Common.Player.PlayerData)
type PlayerData = PlayerData.PlayerData

local PlayerCoins = require(Common.Coins.PlayerCoins)
type PlayerCoins = PlayerCoins.PlayerCoins

local PlayerBombs = require(Common.Bombs.PlayerBombs)
type PlayerBombs = PlayerBombs.PlayerBombs

local PlayerOptions = require(Common.Options.PlayerOptions)
type PlayerOptions = PlayerOptions.PlayerOptions

local PlayerLevel = require(Common.Level.PlayerLevel)
type PlayerLevel = PlayerLevel.PlayerLevel

local PlayerSpeed = require(Common.Speed.PlayerSpeed)
type PlayerSpeed = PlayerSpeed.PlayerSpeed
local PlayerLevelRewards = require(Common.Level.PlayerLevelRewards)
type PlayerLevelRewards = PlayerLevelRewards.PlayerLevelRewards
local PlayerRevives = require(Common.Revives.PlayerRevives)
type PlayerRevives = PlayerRevives.PlayerRevives

local PlayerTrails = require(Common.Trails.PlayerTrails)
type PlayerTrails = PlayerTrails.PlayerTrails

local PlayerSpins = require(Common.Spins.PlayerSpins)
type PlayerSpins = PlayerSpins.PlayerSpins

local PlayerDailyRewards = require(Common.DailyRewards.PlayerDailyRewards)
type PlayerDailyRewards = PlayerDailyRewards.PlayerDailyRewards

export type ServerPlayer = {
    Scope: UnknownScope,
    Player: Player,
    JoinTime: number,

    Coins: PlayerCoins,
    Bombs: PlayerBombs,
    Options: PlayerOptions,
    Level: PlayerLevel,
    Speed: PlayerSpeed,
    LevelRewards: PlayerLevelRewards,
    Revives: PlayerRevives,
    Trails: PlayerTrails,
    Spins: PlayerSpins,
    DailyRewards: PlayerDailyRewards,
}

local function ServerPlayer(scope: FusionScope, player: Player, joinTime: number, data: PlayerData): ServerPlayer
    local coins = PlayerCoins(scope, data.Coins)
    local bombs = PlayerBombs(scope, data.Bombs)
    local options = PlayerOptions(scope, data.Options)
    local level = PlayerLevel(scope, data.Level)
    local speed = PlayerSpeed(scope, data.Speed)
    local levelRewards = PlayerLevelRewards(scope, data.LevelRewards)
    local revives = PlayerRevives(scope, data.Revives)
    local trails = PlayerTrails(scope, data.Trails)
    local spins = PlayerSpins(scope, data.Spins)

    local self: ServerPlayer = {
        Scope = scope,
        Player = player,
        JoinTime = joinTime,

        Coins = coins,
        Bombs = bombs,
        Options = options,
        Level = level,
        Speed = speed,
        LevelRewards = levelRewards,
        Revives = revives,
        Trails = trails,
        Spins = spins,
        DailyRewards = PlayerDailyRewards(scope, data.DailyRewards),
    }

    return self
end

return ServerPlayer
