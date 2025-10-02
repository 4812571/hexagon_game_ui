local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)

local Icons = require(Common.Icons)

local Window = require(Client.Interface.Window)

export type TimedRewardsWindowProps = {
    Scope: Fusion.Scope<typeof(Fusion)>,
}

local function TimedRewardsWindow(props: TimedRewardsWindowProps)
    return Window {
        Scope = props.Scope,
        Title = "Rewards",
        Icon = Icons.Gift,
    }
end

return TimedRewardsWindow