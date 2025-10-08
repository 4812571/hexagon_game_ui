local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)
local peek = Fusion.peek
type Scope = Fusion.Scope<typeof(Fusion)>
type Value<T> = Fusion.Value<T>

local Rewards = require(Common.Rewards)
type Reward = Rewards.Reward

local NetworkClient = require(ReplicatedStorage.NetworkClient)

local ClientPlayer = require(Client.Player.ClientPlayer)
type ClientPlayer = ClientPlayer.ClientPlayer

type SpinController = {
    Start: () -> (),
    Spin: () -> (),
}

local function SpinController(scope: Scope, player: ClientPlayer): SpinController
    local function ClaimReward()
        local reward = peek(player.Spins.PendingReward)

        if not reward then
            warn("[SpinController] No pending reward to claim")
            return
        end

        print(`[SpinController] Claimed reward: {reward.Type}`)
        NetworkClient.Spins.ClaimReward.Invoke()
    end

    local function Start()
        if peek(player.Spins.PendingReward) then
            ClaimReward()
        end
    end

    local function Spin()
        local reward = NetworkClient.Spins.PerformSpin.Invoke()
        player.Spins.PerformSpin(reward)

        -- TODO: wait for animation
        task.delay(3, function()
            ClaimReward()
        end)
    end

    local self: SpinController = {
        Start = Start,
        Spin = Spin,
    }

    return self
end

return SpinController