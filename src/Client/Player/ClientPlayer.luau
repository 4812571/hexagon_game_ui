local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
export type Scope = Fusion.Scope<typeof(Fusion)>
export type Value<T> = Fusion.Value<T>

local PlayerData = require(ReplicatedStorage.Common.Player.PlayerData)
type PlayerData = PlayerData.PlayerData

local PlayerCoins = require(ReplicatedStorage.Common.Coins.PlayerCoins)
type PlayerCoins = PlayerCoins.PlayerCoins

local PlayerLevel = require(ReplicatedStorage.Common.Level.PlayerLevel)
type PlayerLevel = PlayerLevel.PlayerLevel

local PlayerLevelRewards = require(ReplicatedStorage.Common.Level.PlayerLevelRewards)
type PlayerLevelRewards = PlayerLevelRewards.PlayerLevelRewards

local PlayerBombs = require(ReplicatedStorage.Common.Bombs.PlayerBombs)
type PlayerBombs = PlayerBombs.PlayerBombs

local PlayerOptions = require(ReplicatedStorage.Common.Options.PlayerOptions)
type PlayerOptions = PlayerOptions.PlayerOptions

local PlayerSpeed = require(ReplicatedStorage.Common.Speed.PlayerSpeed)
type PlayerSpeed = PlayerSpeed.PlayerSpeed

local PlayerRevives = require(ReplicatedStorage.Common.Revives.PlayerRevives)
type PlayerRevives = PlayerRevives.PlayerRevives

local PlayerTrails = require(ReplicatedStorage.Common.Trails.PlayerTrails)
type PlayerTrails = PlayerTrails.PlayerTrails

local PlayerSpins = require(ReplicatedStorage.Common.Spins.PlayerSpins)
type PlayerSpins = PlayerSpins.PlayerSpins

local PlayerDailyRewards = require(ReplicatedStorage.Common.DailyRewards.PlayerDailyRewards)
type PlayerDailyRewards = PlayerDailyRewards.PlayerDailyRewards

export type ClientPlayer = {
    JoinTime: number,

    Coins: PlayerCoins,
    Level: PlayerLevel,
    LevelRewards: PlayerLevelRewards,
    Bombs: PlayerBombs,
    Revives: PlayerRevives,
    Options: PlayerOptions,
    Speed: PlayerSpeed,
    Trails: PlayerTrails,
    Spins: PlayerSpins,
    DailyRewards: PlayerDailyRewards,
}

local function ClientPlayer(scope: Scope, joinTime: number, data: PlayerData): ClientPlayer
    local self: ClientPlayer = {
        JoinTime = joinTime,

        Coins = PlayerCoins(scope, data.Coins),
        Level = PlayerLevel(scope, data.Level),
        LevelRewards = PlayerLevelRewards(scope, data.LevelRewards),
        Bombs = PlayerBombs(scope, data.Bombs),
        Revives = PlayerRevives(scope, data.Revives),
        Options = PlayerOptions(scope, data.Options),
        Speed = PlayerSpeed(scope, data.Speed),
        Trails = PlayerTrails(scope, data.Trails),
        Spins = PlayerSpins(scope, data.Spins),
        DailyRewards = PlayerDailyRewards(scope, data.DailyRewards),
    }

    return self
end

return ClientPlayer
