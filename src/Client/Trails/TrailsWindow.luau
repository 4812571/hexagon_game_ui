--!strict
--!native
--!nolint LocalShadow

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)

type Scope<T> = Fusion.Scope<typeof(Fusion) & T>

local Icons = require(Common.Icons)

local Window = require(Client.Interface.Window)

export type TrailsWindowProps = {}

local function TrailsWindow<U>(scope: Scope<U>, props: TrailsWindowProps)
    local scope = scope:innerScope {
        Window = Window,
    }

    return scope:Window {
        Title = "Trails",
        Icon = Icons.Aura,
        IconScale = 1.45,
    }
end

return TrailsWindow
