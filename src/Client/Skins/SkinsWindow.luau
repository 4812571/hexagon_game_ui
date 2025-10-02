local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)

local Icons = require(Common.Icons)

local Window = require(Client.Interface.Window)

export type SkinsWindowProps = {
    Scope: Fusion.Scope<typeof(Fusion)>,
}

local function SkinsWindow(props: SkinsWindowProps)
    return Window {
        Scope = props.Scope,
        Title = "Skins",
        Icon = Icons.Pencil,
    }
end

return SkinsWindow