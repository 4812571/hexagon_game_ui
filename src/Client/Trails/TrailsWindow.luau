local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)

local Icons = require(Common.Icons)

local Window = require(Client.Interface.Window)

export type TrailsWindowProps = {
    Scope: Fusion.Scope<typeof(Fusion)>,
}

local function TrailsWindow(props: TrailsWindowProps)
    return Window {
        Scope = props.Scope,
        Title = "Trails",
        Icon = Icons.Aura,
        IconScale = 1.1,
    }
end

return TrailsWindow