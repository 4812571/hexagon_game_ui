local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)
type Scope = Fusion.Scope<typeof(Fusion)>

local ApplyReward = require(Common.Rewards.ApplyReward)
local DailyRewards = require(Common.DailyRewards.DailyRewards)

local NetworkClient = require(ReplicatedStorage.NetworkClient)

local ClientPlayer = require(Client.Player.ClientPlayer)
type ClientPlayer = ClientPlayer.ClientPlayer

export type DailyRewardsController = {
    TryClaim: (instant: number) -> boolean,
}

local function DailyRewardsController(scope: Scope, player: ClientPlayer): DailyRewardsController
    local function TryClaim(instant: number): boolean
        if not player.DailyRewards.CanClaim(instant) then
            return false
        end

        local claimIndex = player.DailyRewards.PerformClaim(instant, #DailyRewards)
        ApplyReward(player, DailyRewards[claimIndex] :: DailyRewards.DailyReward)
        NetworkClient.DailyRewards.ClaimReward.Invoke(instant)

        return true
    end

    local self: DailyRewardsController = {
        TryClaim = TryClaim,
    }

    return self
end

return DailyRewardsController