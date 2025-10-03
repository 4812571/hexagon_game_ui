local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Server = ServerScriptService.Server

local Fusion = require(Packages.Fusion)
type Scope = Fusion.Scope<unknown>

local Signal = require(Common.Signal)
type Signal<T...> = Signal.Signal<T...>

local Observe = require(Packages.Observe)
type Handler<T...> = Observe.Handler<T...>
type Cleanup = Observe.Cleanup

local ServerPlayer = require(Server.Player.ServerPlayer)
type ServerPlayer = ServerPlayer.ServerPlayer

type Map<K, V> = { [K]: V }

export type PlayerService = {
    Mount: (player: Player, serverPlayer: ServerPlayer) -> (),
    Unmount: (player: Player) -> (),

    Get: (player: Player) -> ServerPlayer?,
    GetAll: () -> { ServerPlayer },

    PlayerAdded: Signal<ServerPlayer>,
    PlayerRemoving: Signal<ServerPlayer>,

    ObservePlayers: (handler: Handler<ServerPlayer>) -> Cleanup,
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
        local entry = players[player]

        if not entry then
            return
        end

        entry.Scope:doCleanup()

        players[player] = nil
        playerRemoving:Fire(entry.ServerPlayer)
    end

    local function Get(player: Player): ServerPlayer?
        local entry = players[player]

        if not entry then
            return nil
        end 

        return entry.ServerPlayer
    end

    local function GetAll(): { ServerPlayer }
        local all = {}

        for _, player in players do
            table.insert(all, player)
        end

        return all
    end

    local function ObservePlayers(handler: Handler<ServerPlayer>): Cleanup
        return Observe.AddedRemovedSignal(GetAll(), playerAdded, playerRemoving, handler)
    end

    local self = {
        Mount = Mount,
        Unmount = Unmount,

        Get = Get,
        GetAll = GetAll,

        PlayerAdded = playerAdded,
        PlayerRemoving = playerRemoving,

        ObservePlayers = ObservePlayers,
    }

    return self
end

return PlayerService