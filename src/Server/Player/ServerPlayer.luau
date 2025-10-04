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

export type ServerPlayer = {
    Scope: UnknownScope,
    Player: Player,
    JoinTime: number,

    Coins: ServerCoins,
}

local function ServerPlayer(scope: FusionScope, player: Player, joinTime: number, data: PlayerData): ServerPlayer
    local coins = ServerCoins(scope, data.Coins)

    local self: ServerPlayer = {
        Scope = scope,
        Player = player,
        JoinTime = joinTime,

        Coins = coins,
    }

    return self
end

return ServerPlayer