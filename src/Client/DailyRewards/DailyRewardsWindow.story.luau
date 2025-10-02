local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Client = ReplicatedStorage.Client


local Fusion = require(Packages.Fusion)

local DailyRewards = require(Common.DailyRewards)

local DailyRewardsWindow = require(Client.DailyRewards.DailyRewardsWindow)
type ClaimState = DailyRewardsWindow.ClaimState
type DailyRewardEntry = DailyRewardsWindow.DailyRewardEntry

local function StateFromDay(day: number, currentDay: number): ClaimState
    if day < currentDay then
        return "Claimed"
    elseif day == currentDay then
        return "Available"
    else
        return "NotAvailable"
    end
end

return function(target: Instance)
    local scope = Fusion.scoped(Fusion)

    local entries = {}

    for day, reward in DailyRewards do
        local entry: DailyRewardEntry = {
            Day = day,
            Reward = reward,
            ClaimState = StateFromDay(day, 3),
        }

        table.insert(entries, entry)
    end

    local window = DailyRewardsWindow {
        Scope = scope,
        Rewards = entries,

        OnClaim = function(day: number)
            print("Claimed day", day)
        end,
    }

    window.Parent = target

    return function()
        scope:doCleanup()
    end
end