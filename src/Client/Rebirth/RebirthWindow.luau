--!strict
--!nolint LocalShadow

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)

type Scope<T> = Fusion.Scope<typeof(Fusion) & T>

local Icons = require(Common.Icons)

local Window = require(Client.Interface.Window)

export type RebirthWindowProps = {
    SpeedGain: Fusion.UsedAs<number>,
    IncomeGain: Fusion.UsedAs<number>,

    BombGain: Fusion.UsedAs<number>,
    GoldBombGain: Fusion.UsedAs<number>,
    NukeGain: Fusion.UsedAs<number>,

    Level: Fusion.UsedAs<number>,
    RequiredLevel: Fusion.UsedAs<number>,

    Coins: Fusion.UsedAs<number>,
    RequiredCoins: Fusion.UsedAs<number>,
}

local function RebirthWindow<U>(scope: Scope<U>, props: RebirthWindowProps)
    local scope = scope:innerScope {
        Window = Window,
    }

    return scope:Window {
        Title = "Rebirth",
        Icon = Icons.Rebirth,
        IconScale = 1.35,
    }
end

return RebirthWindow