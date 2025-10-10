--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Server = ServerScriptService.Server

local Fusion = require(Packages.Fusion)
type Scope = Fusion.Scope<unknown>

local Signal = require(Common.Signal)
type Signal<T...> = Signal.Signal<T...>

local Terminate = require(Common.Player.Terminate)

local Observe = require(Packages.Observe)
type Handler<T...> = Observe.Handler<T...>
type Cleanup = Observe.Cleanup

local ServerPlayer = require(Server.Player.ServerPlayer)
export type ServerPlayer = ServerPlayer.ServerPlayer

type Map<K, V> = { [K]: V }

export type PlayerService = {
    Mount: (player: Player, serverPlayer: ServerPlayer) -> (),
    Unmount: (player: Player) -> (),

    Get: (player: Player) -> ServerPlayer?,
    Expect: (player: Player) -> ServerPlayer,
    GetAll: () -> { ServerPlayer },

    PlayerAdded: Signal<ServerPlayer>,
    PlayerRemoving: Signal<ServerPlayer>,

    FireAll: <T...>(event: BlinkEvent<T...>, T...) -> (),
    ObservePlayers: (handler: Handler<ServerPlayer>) -> Cleanup,
}

type BlinkEvent<T...> = {
    Fire: (player: Player, T...) -> (),
}

local function PlayerService(scope: Scope): PlayerService
    local players: Map<Player, ServerPlayer> = {}

    local playerAdded: Signal<ServerPlayer> = Signal(scope)
    local playerRemoving: Signal<ServerPlayer> = Signal(scope)

    local function Mount(player: Player, serverPlayer: ServerPlayer)
        if players[player] then
            return
        end

        players[player] = serverPlayer
        playerAdded:Fire(serverPlayer)
    end

    local function Unmount(player: Player)
        local serverPlayer = players[player]

        if not serverPlayer then
            return
        end

        Fusion.doCleanup(serverPlayer.Scope)

        players[player] = nil
        playerRemoving:Fire(serverPlayer)
    end

    local function Get(player: Player): ServerPlayer?
        return players[player]
    end

    local function Expect(player: Player): ServerPlayer
        local serverPlayer = Get(player)

        if not serverPlayer then
            return Terminate(player, "Expected player to be loaded!", 2)
        end

        return serverPlayer
    end

    local function GetAll(): { ServerPlayer }
        local all = {}

        for _, player in players do
            table.insert(all, player)
        end

        return all
    end

    local function FireAll<T...>(event: BlinkEvent<T...>, ...: T...)
        for _, player in players do
            event.Fire(player.Player, ...)
        end
    end

    local function ObservePlayers(handler: Handler<ServerPlayer>): Cleanup
        return Observe.AddedRemovedSignal(GetAll(), playerAdded, playerRemoving, handler)
    end

    local self = {
        Mount = Mount,
        Unmount = Unmount,

        Get = Get,
        Expect = Expect,
        GetAll = GetAll,

        PlayerAdded = playerAdded,
        PlayerRemoving = playerRemoving,

        FireAll = FireAll,
        ObservePlayers = ObservePlayers,
    }

    return self
end

return PlayerService