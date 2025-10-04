local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common

local Fusion = require(Packages.Fusion)
type Value<T> = Fusion.Value<T>
type UnknownScope = Fusion.Scope<unknown>
type FusionScope = Fusion.Scope<typeof(Fusion)>

local PlayerData = require(Common.Player.PlayerData)
type PlayerData = PlayerData.PlayerData

export type ServerPlayer = {
    Scope: UnknownScope,
    Player: Player,
    JoinTime: number,
}

local function ServerPlayer(scope: FusionScope, player: Player, joinTime: number, data: PlayerData): ServerPlayer
    local self: ServerPlayer = {
        Scope = scope,
        Player = player,
        JoinTime = joinTime,
    }

    return self
end

return ServerPlayer