--!strict
--!native

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Client = ReplicatedStorage.Client

local ClientPlayer = require(Client.Player.ClientPlayer)
type ClientPlayer = ClientPlayer.ClientPlayer

local NetworkClient = require(ReplicatedStorage.NetworkClient)

local Fusion = require(Packages.Fusion)
local peek = Fusion.peek
type Scope = Fusion.Scope<typeof(Fusion)>

export type OptionsController = {
    Start: () -> (),
}

local function OptionsController(scope: Scope, player: ClientPlayer): OptionsController
    local options = player.Options
    
    local function Start()
        scope:Observer(options.MusicVolume):onChange(function()
            NetworkClient.Options.SetMusicVolume.Invoke(peek(options.MusicVolume))
        end)

        scope:Observer(options.SFXVolume):onChange(function()
            NetworkClient.Options.SetSFXVolume.Invoke(peek(options.SFXVolume))
        end)

        scope:Observer(options.NightMode):onChange(function()
            NetworkClient.Options.SetNightMode.Invoke(peek(options.NightMode))
        end)

        scope:Observer(options.CameraShake):onChange(function()
            NetworkClient.Options.SetCameraShake.Invoke(peek(options.CameraShake))
        end)

        scope:Observer(options.Minimap):onChange(function()
            NetworkClient.Options.SetMinimap.Invoke(peek(options.Minimap))
        end)
    end

    local self: OptionsController = {
        Start = Start,
    }

    return self
end

return OptionsController
