--!strict
--!native
--!nolint LocalShadow

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)
local peek = Fusion.peek
type Scope = Fusion.Scope<typeof(Fusion)>

local ApplyReward = require(Common.Rewards.ApplyReward)
local LevelRewards = require(Common.Level.LevelRewards)

local ClientPlayer = require(Client.Player.ClientPlayer)
type ClientPlayer = ClientPlayer.ClientPlayer

local WindowController = require(Client.Window.WindowController)
local WindowSpring = require(Client.Window.WindowSpring)

local LevelWindow = require(Client.Level.LevelWindow)

export type Controllers = {
    WindowController: WindowController.WindowController,
}

export type LevelRewardsController = {
    TryClaim: (rewardIndex: number) -> boolean,
    Start: () -> (),
}

local function LevelRewardsController(scope: Scope, player: ClientPlayer, controllers: Controllers): LevelRewardsController
    local WindowController = controllers.WindowController
    
    local scope = scope:innerScope {
        LevelWindow = LevelWindow,
        WindowSpring = WindowSpring,
    }
    
    local function TryClaim(rewardIndex: number): boolean
        if peek(player.Level.Level) < rewardIndex then
            return false
        end

        if player.LevelRewards.IsClaimed(rewardIndex) then
            return false
        end

        local reward = LevelRewards[rewardIndex]

        if not reward then
            return false
        end

        player.LevelRewards.Claim(rewardIndex)
        ApplyReward(player, reward :: LevelRewards.LevelReward)
        return true
    end

    local rewardEntries: {LevelWindow.LevelRewardEntry} = {}

    for i, reward in LevelRewards :: {LevelRewards.LevelReward} do
        -- This is bad typing, but fusion didn't handle string literals well.
        local claimState: Fusion.UsedAs<string> = scope:Computed(function(use): LevelWindow.ClaimState
            if use(player.Level.Level) < i then
                return "NotAvailable"
            end

            if use(player.LevelRewards.ClaimedIndexes)[i] == true then
                return "Claimed"
            end

            return "Available"
        end)

        local entry: LevelWindow.LevelRewardEntry = {
            Level = i,
            Reward = reward,
            ClaimState = (claimState :: any) :: Fusion.UsedAs<LevelWindow.ClaimState>,
            
            OnClaim = function()
                TryClaim(i)
            end,
        }

        table.insert(rewardEntries, entry)
    end

    local windowScale = scope:WindowSpring("Level", WindowController.CurrentWindow)

    local levelWindow = scope:LevelWindow {
        Scale = windowScale,

        Visible = scope:Computed(function(use)
            return use(windowScale) > 0
        end),

        Experience = player.Level.Experience,
        Level = player.Level.Level,
        ExperienceToNextLevel = player.Level.RequiredExperience,
        Speed = player.Speed.Speed,
        Rewards = rewardEntries,

        OnClose = function()
            WindowController.CloseWindow()
        end,
    }

    local function Start()
        local screenGui = Instance.new("ScreenGui")
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        
        levelWindow.Parent = screenGui
        screenGui.Parent = player.Player.PlayerGui
    end

    local self: LevelRewardsController = {
        TryClaim = TryClaim,
        Start = Start,
    }

    return self
end

return LevelRewardsController
