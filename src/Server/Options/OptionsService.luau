local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Server = ServerScriptService.Server

local Fusion = require(Packages.Fusion)
type Scope = Fusion.Scope<typeof(Fusion)>

local Terminate = require(Common.Player.Terminate)

local NetworkServer = require(ServerScriptService.NetworkServer)

local PlayerService = require(Server.Player.PlayerService)

export type Services = {
    PlayerService: PlayerService.PlayerService,
}

export type OptionsService = {
    Start: () -> (),
}

local function OptionsService(scope: Scope, services: Services): OptionsService
    local PlayerService = services.PlayerService

    local function OnSetMusicVolume(player: Player, volume: number)
        local serverPlayer = PlayerService.Get(player)

        if not serverPlayer then
            return Terminate(player, "Player not found in OptionsService.OnSetMusicVolume")
        end

        serverPlayer.Options.MusicVolume:set(volume)
        return
    end

    local function OnSetSFXVolume(player: Player, volume: number)
        local serverPlayer = PlayerService.Get(player)

        if not serverPlayer then
            return Terminate(player, "Player not found in OptionsService.OnSetSFXVolume")
        end

        serverPlayer.Options.SFXVolume:set(volume)
        return
    end

    local function OnSetNightMode(player: Player, nightMode: boolean)
        local serverPlayer = PlayerService.Get(player)

        if not serverPlayer then
            return Terminate(player, "Player not found in OptionsService.OnSetNightMode")
        end

        serverPlayer.Options.NightMode:set(nightMode)
        return
    end

    local function OnSetCameraShake(player: Player, cameraShake: boolean)
        local serverPlayer = PlayerService.Get(player)

        if not serverPlayer then
            return Terminate(player, "Player not found in OptionsService.OnSetCameraShake")
        end

        serverPlayer.Options.CameraShake:set(cameraShake)
        return
    end

    local function OnSetMinimap(player: Player, minimap: boolean)
        local serverPlayer = PlayerService.Get(player)

        if not serverPlayer then
            return Terminate(player, "Player not found in OptionsService.OnSetMinimap")
        end

        serverPlayer.Options.Minimap:set(minimap)
        return
    end

    local function Start()
        NetworkServer.Options.SetMusicVolume.On(OnSetMusicVolume)
        NetworkServer.Options.SetSFXVolume.On(OnSetSFXVolume)
        NetworkServer.Options.SetNightMode.On(OnSetNightMode)
        NetworkServer.Options.SetCameraShake.On(OnSetCameraShake)
        NetworkServer.Options.SetMinimap.On(OnSetMinimap)
    end

    local self: OptionsService = {
        Start = Start,
    }

    return self
end

return OptionsService