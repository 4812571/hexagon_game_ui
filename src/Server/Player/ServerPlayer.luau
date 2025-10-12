--!strict
--!native

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common

local Fusion = require(Packages.Fusion)
type Scope<T> = Fusion.Scope<T>

local PlayerData = require(Common.Player.PlayerData)
type PlayerData = PlayerData.PlayerData

local CommonPlayer = require(Common.Player.CommonPlayer)
export type ServerPlayer = CommonPlayer.CommonPlayer

local function ServerPlayer(scope: Scope<typeof(Fusion)>, player: Player, joinTime: number, data: PlayerData): ServerPlayer
    return CommonPlayer(scope, player, joinTime, data)
end

return ServerPlayer
