local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
export type Scope = Fusion.Scope<typeof(Fusion)>
export type Value<T> = Fusion.Value<T>

local PlayerData = require(ReplicatedStorage.Common.Player.PlayerData)
type PlayerData = PlayerData.PlayerData

local ClientCoins = require(ReplicatedStorage.Client.Coins.ClientCoins)
type ClientCoins = ClientCoins.ClientCoins

local ClientLevel = require(ReplicatedStorage.Client.Level.ClientLevel)
type ClientLevel = ClientLevel.ServerLevel

export type ClientPlayer = {
    JoinTime: number,

    Coins: ClientCoins,
    Level: ClientLevel,
}

local function ClientPlayer(scope: Scope, joinTime: number, data: PlayerData): ClientPlayer
    local self: ClientPlayer = {
        JoinTime = joinTime,

        Coins = ClientCoins(scope, data.Coins),
        Level = ClientLevel(scope, data.Level),
    }

    return self
end

return ClientPlayer