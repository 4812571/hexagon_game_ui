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
export type ClientPlayer = CommonPlayer.CommonPlayer

local function ClientPlayer(scope: Scope<typeof(Fusion)>, player: Player, joinTime: number, data: PlayerData): ClientPlayer
    return CommonPlayer(scope, player, joinTime, data)
end

return ClientPlayer
