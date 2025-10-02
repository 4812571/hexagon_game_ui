local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)
local peek = Fusion.peek

local OptionsWindow = require(Client.Options.OptionsWindow)

local function Percent(value: number): string
    return `{math.floor(value * 100)}%`
end

local function Enabled(bool: boolean): string
    return if bool then "enabled" else "disabled"
end

return function(target: Instance)
    local scope = Fusion.scoped(Fusion)

    local musicVolume = scope:Value(0.5)
    local soundEffectsVolume = scope:Value(0.5)
    local nightModeEnabled = scope:Value(false)
    local cameraShakeEnabled = scope:Value(true)
    local minimapEnabled = scope:Value(true)

    scope:Observer(musicVolume, function()
        print(`Music volume set to {Percent(peek(musicVolume))}`)
    end)

    scope:Observer(soundEffectsVolume, function()
        print(`Sound effects volume set to {Percent(peek(soundEffectsVolume))}`)
    end)

    scope:Observer(nightModeEnabled, function()
        print(`Night mode {Enabled(peek(nightModeEnabled))}`)
    end)

    scope:Observer(cameraShakeEnabled, function()
        print(`Camera shake {Enabled(peek(cameraShakeEnabled))}`)
    end)

    scope:Observer(minimapEnabled, function()
        print(`Minimap {Enabled(peek(minimapEnabled))}`)
    end)

    local window = OptionsWindow {
        Scope = scope,

        MusicVolume = musicVolume,
        SoundEffectsVolume = soundEffectsVolume,
        NightModeEnabled = nightModeEnabled,
        CameraShakeEnabled = cameraShakeEnabled,
        MinimapEnabled = minimapEnabled,
    }

    window.Parent = target

    return function()
        scope:doCleanup()
    end
end
