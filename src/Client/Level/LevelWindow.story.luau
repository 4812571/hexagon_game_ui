local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Client = ReplicatedStorage.Client

local LevelRewards = require(Common.LevelRewards)

local Fusion = require(Packages.Fusion)

local LevelWindow = require(Client.Level.LevelWindow)
type ClaimState = LevelWindow.ClaimState
type LevelRewardEntry = LevelWindow.LevelRewardEntry

local function StateFromLevel(level: number, currentLevel: number): ClaimState
    if level < currentLevel then
        return "Claimed"
    elseif level == currentLevel then
        return "Available"
    else
        return "NotAvailable"
    end
end

return function(target: Instance)
    local scope = Fusion.scoped(Fusion)

    local currentLevel = 5

    local entries = {}

    for level, reward in LevelRewards do
        local entry: LevelRewardEntry = {
            Level = level,
            Reward = reward,
            ClaimState = StateFromLevel(level, currentLevel),
        }

        table.insert(entries, entry)
    end

    local window = LevelWindow {
        Scope = scope,
        
        Level = currentLevel,
        Experience = 40,
        ExperienceToNextLevel = 95,
        Speed = 25,
        Rewards = entries,

        OnClaim = function(level: number)
            print("Claimed level", level)
        end,
    }

    window.Parent = target

    return function()
        scope:doCleanup()
    end
end
