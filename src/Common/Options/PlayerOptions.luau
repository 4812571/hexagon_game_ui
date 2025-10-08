local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common

local Fusion = require(Packages.Fusion)
local peek = Fusion.peek
type Scope = Fusion.Scope<typeof(Fusion)>
type Value<T> = Fusion.Value<T>

local OptionsData = require(Common.Options.OptionsData)
type OptionsData = OptionsData.OptionsData

export type PlayerOptions = {
    MusicVolume: Value<number>,
    SFXVolume: Value<number>,
    NightMode: Value<boolean>,
    CameraShake: Value<boolean>,
    Minimap: Value<boolean>,
}

local function PlayerOptions(scope: Scope, data: OptionsData): PlayerOptions
    local musicVolume = scope:Value(data.MusicVolume)
    local sfxVolume = scope:Value(data.SFXVolume)
    local nightMode = scope:Value(data.NightMode)
    local cameraShake = scope:Value(data.CameraShake)
    local minimap = scope:Value(data.Minimap)

    if RunService:IsServer() then
        scope:Observer(musicVolume):onChange(function()
            data.MusicVolume = peek(musicVolume)
        end)

        scope:Observer(sfxVolume):onChange(function()
            data.SFXVolume = peek(sfxVolume)
        end)

        scope:Observer(nightMode):onChange(function()
            data.NightMode = peek(nightMode)
        end)

        scope:Observer(cameraShake):onChange(function()
            data.CameraShake = peek(cameraShake)
        end)

        scope:Observer(minimap):onChange(function()
            data.Minimap = peek(minimap)
        end)
    end

    local self = {
        MusicVolume = musicVolume,
        SFXVolume = sfxVolume,
        NightMode = nightMode,
        CameraShake = cameraShake,
        Minimap = minimap,
    }

    return self
end

return PlayerOptions
