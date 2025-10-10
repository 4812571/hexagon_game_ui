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
        PlayerService.Expect(player).Options.MusicVolume:set(volume)
    end

    local function OnSetSFXVolume(player: Player, volume: number)
        PlayerService.Expect(player).Options.SFXVolume:set(volume)
    end

    local function OnSetNightMode(player: Player, nightMode: boolean)
        PlayerService.Expect(player).Options.NightMode:set(nightMode)
    end

    local function OnSetCameraShake(player: Player, cameraShake: boolean)
        PlayerService.Expect(player).Options.CameraShake:set(cameraShake)
    end

    local function OnSetMinimap(player: Player, minimap: boolean)
        PlayerService.Expect(player).Options.Minimap:set(minimap)
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