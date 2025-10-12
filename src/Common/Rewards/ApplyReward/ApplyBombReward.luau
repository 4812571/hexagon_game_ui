--!strict
--!native

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common

local Fusion = require(Packages.Fusion)
local peek = Fusion.peek

local CommonPlayer = require(Common.Player.CommonPlayer)
type CommonPlayer = CommonPlayer.CommonPlayer

local Rewards = require(Common.Rewards.Rewards)
type BombReward = Rewards.BombReward

local function ApplyBombReward(player: CommonPlayer, reward: BombReward)
    local bombs = player.Bombs
    
    if reward.BombType == "Bomb" then
        bombs.Bombs:set(peek(bombs.Bombs) + reward.Amount)
    end
    
    if reward.BombType == "GoldBomb" then
        bombs.GoldBombs:set(peek(bombs.GoldBombs) + reward.Amount)
    end

    if reward.BombType == "Nuke" then
        bombs.Nukes:set(peek(bombs.Nukes) + reward.Amount)
    end

    error("[ApplyBombReward] Unknown bomb type: " .. tostring(reward.BombType))
end

return ApplyBombReward
