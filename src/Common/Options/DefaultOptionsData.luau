local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage.Common

local OptionsData = require(Common.Options.OptionsData)
type OptionsData = OptionsData.OptionsData

local DefaultOptionsData: OptionsData = {
    MusicVolume = 1.0,
    SFXVolume = 1.0,
    NightMode = false,
    CameraShake = true,
    Minimap = true,
}

return DefaultOptionsData