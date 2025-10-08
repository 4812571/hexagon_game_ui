--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Server = ServerScriptService.Server

local Fusion = require(Packages.Fusion)
local peek = Fusion.peek
type Scope = Fusion.Scope<typeof(Fusion)>
type Value<T> = Fusion.Value<T>

local Counter = require(Common.Util.Counter)
local BombsConfig = require(Common.Bombs.BombsConfig)
type BombConfig = BombsConfig.BombConfig

local HexagonUtil = require(Common.Hexagon.HexagonUtil)
local HexagonConfig = require(Common.Hexagon.HexagonConfig)

local NetworkServer = require(ServerScriptService.NetworkServer)

local PlayerService = require(Server.Player.PlayerService)
local AuthoritativeTimingService = require(Server.AuthoritativeTimingService)
local HexagonService = require(Server.Hexagon.HexagonService)

type PlayerService = PlayerService.PlayerService
type AuthoritativeTimingService = AuthoritativeTimingService.AuthoritativeTimingService
type HexagonService = HexagonService.HexagonService

type ServerPlayer = PlayerService.ServerPlayer

export type BombService = {
    Start: () -> (),
}

type Services = {
    AuthoritativeTimingService: AuthoritativeTimingService,
    HexagonService: HexagonService,
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
        return BombsConfig.Bomb.Cooldown
    end

    if bombType == "GoldBomb" then
        return BombsConfig.GoldBomb.Cooldown
    end

    if bombType == "Nuke" then
        return BombsConfig.Nuke.Cooldown
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
    local HexagonService = services.HexagonService

    PlayerService.ObservePlayers(function(player: ServerPlayer)
        player.Bombs.Bombs:set(10)
        player.Bombs.GoldBombs:set(8)
        player.Bombs.Nukes:set(3)

        return nil
    end)

    local nextBombIndex = Counter()

    local function BombTask(player: ServerPlayer, bomb: BombConfig, axial: HexagonUtil.Axial)
        local hexPlayer = HexagonService.GetPlayer(player)

        if not hexPlayer then
            return
        end

        for i = 0, bomb.BlastRadius do
            local currentHexPlayer = HexagonService.GetPlayer(player)

            if currentHexPlayer ~= hexPlayer then
                return
            end

            local ringAxials = HexagonUtil.Ring(i)

            local inBoundsAxials = {}

            for _, ringAxial in ringAxials do
                local targetAxial = HexagonUtil.Add(axial, ringAxial)

                if HexagonUtil.IsInBounds(targetAxial, HexagonConfig.WorldRadius) then
                    table.insert(inBoundsAxials, targetAxial)
                end
            end

            HexagonService.FloodTiles(hexPlayer, inBoundsAxials)
            HexagonService.FinishSelection(hexPlayer)
            task.wait(0.25)
        end
    end

    local function HandleUse(player: Player, bombType: BombType, clientTime: number)
        local serverPlayer = PlayerService.Get(player)
        print(serverPlayer)

        if not serverPlayer then
            KickAndError(player, "[BombService] No player data found.")
            return
        end

        if not AuthoritativeTimingService.Register(player, clientTime) then
            KickAndError(player, "[BombService] Client time is out of sync.")
            return
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

        local character = player.Character

        if not character then
            return
        end

        local bombIndex = nextBombIndex()

        local axial = HexagonUtil.WorldToNearestAxial(character:GetPivot().Position / HexagonConfig.HexagonSize)
        local playerAxial = HexagonUtil.ClampToBounds(axial, HexagonConfig.WorldRadius)
        NetworkServer.Bombs.BombDeployed.FireAll(bombType, playerAxial, bombIndex)

        local bomb: BombConfig = BombsConfig[bombType]

        task.delay(bomb.FuseTime, function()
            task.spawn(function()
                BombTask(serverPlayer, bomb, playerAxial)
            end)

            NetworkServer.Bombs.BombExploded.FireAll(bombIndex)
        end)
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