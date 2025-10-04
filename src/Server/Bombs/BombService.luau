local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Server = ServerScriptService.Server

local Fusion = require(Packages.Fusion)
local peek = Fusion.peek
type Scope = Fusion.Scope<typeof(Fusion)>
type Value<T> = Fusion.Value<T>

local BombsConfig = require(Common.Bombs.BombsConfig)

local NetworkServer = require(ServerScriptService.NetworkServer)

local PlayerService = require(Server.Player.PlayerService)
type PlayerService = PlayerService.PlayerService
type ServerPlayer = PlayerService.ServerPlayer

local AuthoritativeTimingService = require(Server.AuthoritativeTimingService)
type AuthoritativeTimingService = AuthoritativeTimingService.AuthoritativeTimingService

export type BombService = {
    Start: () -> (),
}

type Services = {
    AuthoritativeTimingService: AuthoritativeTimingService,
    PlayerService: PlayerService,
}

type BombType = "Bomb" | "GoldBomb" | "Nuke"

local function BombValue(player: ServerPlayer, bombType: BombType): Value<number>
    if bombType == "Bomb" then
        return player.Bombs.Bombs
    end

    if bombType == "GoldBomb" then
        return player.Bombs.GoldBombs
    end

    if bombType == "Nuke" then
        return player.Bombs.Nukes
    end

    error("[BombService] Invalid bomb type: " .. bombType)
end

local function TimeValue(player: ServerPlayer, bombType: BombType): Value<number>
    if bombType == "Bomb" then
        return player.Bombs.LastBombTime
    end

    if bombType == "GoldBomb" then
        return player.Bombs.LastGoldBombTime
    end

    if bombType == "Nuke" then
        return player.Bombs.LastNukeTime
    end

    error("[BombService] Invalid bomb type: " .. bombType)
end

local function Cooldown(bombType: BombType): number
    if bombType == "Bomb" then
        return BombsConfig.BombCooldown
    end

    if bombType == "GoldBomb" then
        return BombsConfig.GoldBombCooldown
    end

    if bombType == "Nuke" then
        return BombsConfig.NukeCooldown
    end

    error("[BombService] Invalid bomb type: " .. bombType)
end

local function KickAndError(player: Player, message: string)
    player:Kick(message)
    error(message)
end

local function BombService(scope: Scope, services: Services): BombService
    local PlayerService = services.PlayerService
    local AuthoritativeTimingService = services.AuthoritativeTimingService

    local function HandleUse(player: Player, bombType: BombType, clientTime: number)
        local serverPlayer = PlayerService.Get(player)

        if not serverPlayer then
            KickAndError(player, "[BombService] No player data found.")
        end

        if not AuthoritativeTimingService.Register(player, clientTime) then
            KickAndError(player, "[BombService] Client time is out of sync.")
        end

        local value = BombValue(serverPlayer, bombType)
        local timeValue = TimeValue(serverPlayer, bombType)
        local cooldown = Cooldown(bombType)

        local passedTime = clientTime - peek(timeValue)

        if passedTime < cooldown then
            KickAndError(player, `[BombService] Tried to use {bombType} before cooldown.`)
        end

        if peek(value) <= 0 then
            KickAndError(player, `[BombService] Tried to use {bombType} with none left.`)
        end

        value:set(peek(value) - 1)
        timeValue:set(clientTime)
    end

    local function Start()
        NetworkServer.Bombs.Use.On(HandleUse)
    end

    local self = {
        Start = Start,
    }

    return self
end

return BombService