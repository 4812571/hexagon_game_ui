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

export type ServerPlayer = {
    Scope: UnknownScope,
    Player: Player,
    JoinTime: number,

    Coins: PlayerCoins,
    Bombs: PlayerBombs,
    Options: PlayerOptions,
    Level: PlayerLevel,
    Speed: PlayerSpeed,
}

local function ServerPlayer(scope: FusionScope, player: Player, joinTime: number, data: PlayerData): ServerPlayer
    local coins = PlayerCoins(scope, data.Coins)
    local bombs = PlayerBombs(scope, data.Bombs)
    local options = PlayerOptions(scope, data.Options)
    local level = PlayerLevel(scope, data.Level)
    local speed = PlayerSpeed(scope, data.Speed)

    local self: ServerPlayer = {
        Scope = scope,
        Player = player,
        JoinTime = joinTime,

        Coins = coins,
        Bombs = bombs,
        Options = options,
        Level = level,
        Speed = speed,
    }

    return self
end

return ServerPlayer
