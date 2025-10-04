--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Server = ServerScriptService.Server

local Fusion = require(Packages.Fusion)
type Scope = Fusion.Scope<typeof(Fusion)>
local innerScope = Fusion.innerScope

local Observe = require(Packages.Observe)

local PlayerData = require(Common.Player.PlayerData)
type PlayerData = PlayerData.PlayerData

local DefaultPlayerData = require(Common.Player.DefaultPlayerData)

local InitialData = require(Common.InitialData)
type InitialData = InitialData.InitialData

local NetworkServer = require(ServerScriptService.NetworkServer)

local PlayerDataLoader = require(Server.Player.PlayerDataLoader)
type Profile<T> = PlayerDataLoader.Profile<T>
type PlayerDataLoader<T> = PlayerDataLoader.PlayerDataLoader<T>

local ServerPlayer = require(Server.Player.ServerPlayer)
type ServerPlayer = ServerPlayer.ServerPlayer

local PlayerService = require(Server.Player.PlayerService)
local HexagonService = require(Server.Hexagon.HexagonService)

type PlayerService = PlayerService.PlayerService
type HexagonService = HexagonService.HexagonService

type Set<T> = { [T]: true }
type Map<K, V> = { [K]: V }

type Services = {
    PlayerService: PlayerService,

    HexagonService: HexagonService,
}

export type PlayerJoinService = {
    Start: () -> (),
}

local function PlayerJoinService(scope: Scope, services: Services): PlayerJoinService
    local PlayerService = services.PlayerService
    local HexagonService = services.HexagonService

    local playerDataLoader: PlayerDataLoader<PlayerData> = PlayerDataLoader(scope, "PlayerData_1", DefaultPlayerData)

    local function Join(player: Player): InitialData?
        local profile: Profile<PlayerData>? = playerDataLoader.AwaitProfile(player)
       
        if not profile then
            return nil
        end

        local joinTime = workspace:GetServerTimeNow()

        local serverPlayer = ServerPlayer(innerScope(scope), player, joinTime, profile.Data)
        PlayerService.Mount(player, serverPlayer)

        local initialData: InitialData = {
            JoinTime = joinTime,

            Player = profile.Data,
            Hexagon = HexagonService.InitialData(),
        }

        return initialData
    end

    local function HandlePlayer(player: Player)
        playerDataLoader.AddPlayer(player)

        return function()
            playerDataLoader.RemovePlayer(player)
        end
    end

    local function OnProfileRelease(player: Player)
        PlayerService.Unmount(player)
    end

    local function Start()
        NetworkServer.Join.On(function(player: Player)
            return Join(player)
        end)

        table.insert(scope, Observe.Players(HandlePlayer))
        table.insert(scope, playerDataLoader.ProfileLoaded:Connect(OnProfileRelease))
    end

    local self = {
        Start = Start,
    }

    return self
end

return PlayerJoinService