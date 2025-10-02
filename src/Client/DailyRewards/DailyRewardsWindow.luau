local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)

local Icons = require(Common.Icons)

local Window = require(Client.Interface.Window)

export type DailyRewardsWindowProps = {
    Scope: Fusion.Scope<typeof(Fusion)>,
}

local function DailyRewardsWindow(props: DailyRewardsWindowProps)
    return Window {
        Scope = props.Scope,
        Title = "Daily",
        Icon = Icons.Calendar,
    }
end

return DailyRewardsWindow