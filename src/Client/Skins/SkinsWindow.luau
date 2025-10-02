local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)

local Icons = require(Common.Icons)

local Skins = require(Common.Skins)
type SkinInfo = Skins.SkinInfo

local Window = require(Client.Interface.Window)

export type SkinSection = "Various" | "Flags"

export type SkinEntry = {
    Skin: SkinInfo,
    Owned: Fusion.UsedAs<boolean>,
}

export type SkinsWindowProps = {
    Scope: Fusion.Scope<typeof(Fusion)>,

    Section: Fusion.UsedAs<SkinSection>,
    Skins: Fusion.UsedAs<{SkinEntry}>,
    Selected: Fusion.UsedAs<SkinEntry>,
}

local function SkinsWindow(props: SkinsWindowProps)
    return Window {
        Scope = props.Scope,
        Title = "Skins",
        Icon = Icons.Pencil,
    }
end

return SkinsWindow