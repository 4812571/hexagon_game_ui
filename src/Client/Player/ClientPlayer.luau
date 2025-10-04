local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
export type Scope = Fusion.Scope<typeof(Fusion)>
export type Value<T> = Fusion.Value<T>

local PlayerData = require(ReplicatedStorage.Common.Player.PlayerData)
type PlayerData = PlayerData.PlayerData

export type ClientPlayer = {
    JoinTime: number,

    Coins: Value<number>,
}

local function ClientPlayer(scope: Scope, joinTime: number, data: PlayerData): ClientPlayer
    local self: ClientPlayer = {
        JoinTime = joinTime,

        Coins = scope:Value(data.Coins.Coins),
    }

    return self
end

return ClientPlayer