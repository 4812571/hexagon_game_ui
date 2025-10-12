local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)
local peek = Fusion.peek

local Timer = require(Common.Util.Timer)
local TimedRewards = require(Common.TimedRewards.TimedRewards)

local TimedRewardsWindow = require(Client.TimedRewards.TimedRewardsWindow)
type TimedRewardEntry = TimedRewardsWindow.TimedRewardEntry

return function(target: Instance)
    local scope = Fusion.scoped(Fusion, {
        TimedRewardsWindow = TimedRewardsWindow,
    })

    local passedTime = scope:Value(0)
    
    local entries = {}

    for _, rewardData in TimedRewards do
        local entry: TimedRewardEntry = {
            RewardData = rewardData,
            Claimed = scope:Value(false),
            
            RemainingTime = scope:Computed(function(use)
                return rewardData.Duration - use(passedTime)
            end)
        }

        table.insert(entries, entry)
    end

    local window = scope:TimedRewardsWindow {

        Rewards = entries,

        OnClaim = function(index: number)
            print("Claimed reward", index)
        end
    }

    window.Parent = target

    table.insert(scope, Timer(1, function()
        passedTime:set(peek(passedTime) + 1)
    end))
    
    return function()
        scope:doCleanup()
    end
end
