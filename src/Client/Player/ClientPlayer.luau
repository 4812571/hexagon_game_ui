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

local PlayerBombs = require(ReplicatedStorage.Common.Bombs.PlayerBombs)
type PlayerBombs = PlayerBombs.PlayerBombs

local PlayerOptions = require(ReplicatedStorage.Common.Options.PlayerOptions)
type PlayerOptions = PlayerOptions.PlayerOptions

local PlayerRevives = require(ReplicatedStorage.Common.Revives.PlayerRevives)
type PlayerRevives = PlayerRevives.PlayerRevives

local PlayerTrails = require(ReplicatedStorage.Common.Trails.PlayerTrails)
type PlayerTrails = PlayerTrails.PlayerTrails

export type ClientPlayer = {
    JoinTime: number,

    Coins: PlayerCoins,
    Level: PlayerLevel,
    Bombs: PlayerBombs,
    Revives: PlayerRevives,
    Options: PlayerOptions,
    Trails: PlayerTrails,
}

local function ClientPlayer(scope: Scope, joinTime: number, data: PlayerData): ClientPlayer
    local self: ClientPlayer = {
        JoinTime = joinTime,

        Coins = PlayerCoins(scope, data.Coins),
        Level = PlayerLevel(scope, data.Level),
        Bombs = PlayerBombs(scope, data.Bombs),
        Revives = PlayerRevives(scope, data.Revives),
        Options = PlayerOptions(scope, data.Options),
        Trails = PlayerTrails(scope, data.Trails),
    }

    return self
end

return ClientPlayer
