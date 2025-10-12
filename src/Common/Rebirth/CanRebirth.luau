--!strict
--!native

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common

local Fusion = require(Packages.Fusion)
local peek = Fusion.peek

local CommonPlayer = require(Common.Player.CommonPlayer)
type CommonPlayer = CommonPlayer.CommonPlayer

local RebirthConfig = require(Common.Rebirth.RebirthConfig)

local function CanRebirth(player: CommonPlayer): boolean
    if peek(player.Level.Level) < RebirthConfig.Costs.Level then
        return false
    end

    if peek(player.Coins.Coins) < RebirthConfig.Costs.Coins then
        return false
    end

    return true
end

return CanRebirth
