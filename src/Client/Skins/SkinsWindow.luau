local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)

type Scope<T> = Fusion.Scope<typeof(Fusion) & T>

local Icons = require(Common.Icons)

local Skins = require(Common.Skins.Skins)
type SkinInfo = Skins.SkinInfo

local Window = require(Client.Interface.Window)

export type SkinSection = "Various" | "Flags"

export type SkinEntry = {
    Skin: SkinInfo,
    Owned: Fusion.UsedAs<boolean>,
}

export type SkinsWindowProps = {
    Section: Fusion.UsedAs<SkinSection>,
    Skins: Fusion.UsedAs<{SkinEntry}>,
    Selected: Fusion.UsedAs<SkinEntry>,
}

local function SkinsWindow<U>(scope: Scope<U>, props: SkinsWindowProps)
    local scope = scope:innerScope {
        Window = Window,
    }

    return scope:Window {
        Title = "Skins",
        Icon = Icons.Pencil,
    }
end

return SkinsWindow