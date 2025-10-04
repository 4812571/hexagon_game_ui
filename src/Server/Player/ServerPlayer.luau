local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Server = ServerScriptService.Server

local Fusion = require(Packages.Fusion)
type Value<T> = Fusion.Value<T>
type UnknownScope = Fusion.Scope<unknown>
type FusionScope = Fusion.Scope<typeof(Fusion)>

local PlayerData = require(Common.Player.PlayerData)
type PlayerData = PlayerData.PlayerData

local ServerCoins = require(Server.Coins.ServerCoins)
type ServerCoins = ServerCoins.ServerCoins

local ServerBombs = require(Server.Bombs.ServerBombs)
type ServerBombs = ServerBombs.ServerBombs

local ServerOptions = require(Server.Options.ServerOptions)
type ServerOptions = ServerOptions.ServerOptions

local ServerLevel = require(Server.Level.ServerLevel)
type ServerLevel = ServerLevel.ServerLevel

export type ServerPlayer = {
    Scope: UnknownScope,
    Player: Player,
    JoinTime: number,

    Coins: ServerCoins,
    Bombs: ServerBombs,
    Options: ServerOptions,
    Level: ServerLevel,
}

local function ServerPlayer(scope: FusionScope, player: Player, joinTime: number, data: PlayerData): ServerPlayer
    local coins = ServerCoins(scope, data.Coins)
    local bombs = ServerBombs(scope, data.Bombs)
    local options = ServerOptions(scope, data.Options)
    local level = ServerLevel(scope, data.Level)

    local self: ServerPlayer = {
        Scope = scope,
        Player = player,
        JoinTime = joinTime,

        Coins = coins,
        Bombs = bombs,
        Options = options,
        Level = level,
    }

    return self
end

return ServerPlayer