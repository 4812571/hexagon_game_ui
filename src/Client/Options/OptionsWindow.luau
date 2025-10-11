local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)

type Scope<T> = Fusion.Scope<typeof(Fusion) & T>

local Icons = require(Common.Icons)

local Window = require(Client.Interface.Window)

export type OptionsWindowProps = {
    MusicVolume: Fusion.Value<number>,
    SoundEffectsVolume: Fusion.Value<number>,
    NightModeEnabled: Fusion.Value<boolean>,
    CameraShakeEnabled: Fusion.Value<boolean>,
    MinimapEnabled: Fusion.Value<boolean>,
}

local function OptionsWindow<U>(scope: Scope<U>, props: OptionsWindowProps)
    local scope = scope:innerScope {
        Window = Window,
    }

    return scope:Window {
        Title = "Options",
        Icon = Icons.Gear,
        IconScale = 1.05,
    }
end

return OptionsWindow