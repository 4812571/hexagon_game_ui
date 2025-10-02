local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)

local Icons = require(Common.Icons)

local Window = require(Client.Interface.Window)

export type RebirthWindowProps = {
    Scope: Fusion.Scope<typeof(Fusion)>,

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

local function RebirthWindow(props: RebirthWindowProps)
    return Window {
        Scope = props.Scope,
        Title = "Rebirth",
        Icon = Icons.Rebirth,
    }
end

return RebirthWindow