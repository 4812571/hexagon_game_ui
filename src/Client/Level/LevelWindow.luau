local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)

local Icons = require(Common.Icons)

local Window = require(Client.Interface.Window)

export type LevelWindowProps = {
    Scope: Fusion.Scope<typeof(Fusion)>,
}

local function LevelWindow(props: LevelWindowProps)
    return Window {
        Scope = props.Scope,
        Title = "Level Up",
        Icon = Icons.UpArrow,
    }
end

return LevelWindow