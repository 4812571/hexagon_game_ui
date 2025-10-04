local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common

local Fusion = require(Packages.Fusion)
type Scope = Fusion.Scope<typeof(Fusion)>
type Value<T> = Fusion.Value<T>

local OptionsData = require(Common.Options.OptionsData)
type OptionsData = OptionsData.OptionsData

export type ClientOptions = {
    MusicVolume: Value<number>,
    SFXVolume: Value<number>,
    NightMode: Value<boolean>,
    CameraShake: Value<boolean>,
    Minimap: Value<boolean>,   
}

local function ClientOptions(scope: Scope, data: OptionsData): ClientOptions
    local musicVolume = scope:Value(data.MusicVolume)
    local sfxVolume = scope:Value(data.SFXVolume)
    local nightMode = scope:Value(data.NightMode)
    local cameraShake = scope:Value(data.CameraShake)
    local minimap = scope:Value(data.Minimap)

    local self = {
        MusicVolume = musicVolume,
        SFXVolume = sfxVolume,
        NightMode = nightMode,
        CameraShake = cameraShake,
        Minimap = minimap,
    }

    return self
end

return ClientOptions