local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)

local Icons = require(Common.Icons)

local Window = require(Client.Interface.Window)

export type OptionsWindowProps = {
    Scope: Fusion.Scope<typeof(Fusion)>,

    MusicVolume: Fusion.Value<number>,
    SoundEffectsVolume: Fusion.Value<number>,
    NightModeEnabled: Fusion.Value<boolean>,
    CameraShakeEnabled: Fusion.Value<boolean>,
    MinimapEnabled: Fusion.Value<boolean>,
}

local function OptionsWindow(props: OptionsWindowProps)
    return Window {
        Scope = props.Scope,
        Title = "Options",
        Icon = Icons.Gear,
        IconScale = 1.05,
    }
end

return OptionsWindow