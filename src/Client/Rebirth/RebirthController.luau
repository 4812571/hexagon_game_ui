--!strict
--!native
--!nolint LocalShadow

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)
type Scope = Fusion.Scope<typeof(Fusion)>

local CanRebirth = require(Common.Rebirth.CanRebirth)
local ApplyRebirth = require(Common.Rebirth.ApplyRebirth)
local RebirthConfig = require(Common.Rebirth.RebirthConfig)

local NetworkClient = require(ReplicatedStorage.NetworkClient)

local ClientPlayer = require(Client.Player.ClientPlayer)
type ClientPlayer = ClientPlayer.ClientPlayer

local WindowController = require(Client.Window.WindowController)
local WindowScaling = require(Client.Window.WindowScaling)

local RebirthWindow = require(Client.Rebirth.RebirthWindow)

export type Controllers = {
    WindowController: WindowController.WindowController,
}

export type RebirthController = {
    Start: () -> (),
    TryRebirth: () -> boolean,
}

local function RebirthController(scope: Scope, player: ClientPlayer, controllers: Controllers): RebirthController
    local WindowController = controllers.WindowController
    
    local scope = scope:innerScope {
        WindowScaling = WindowScaling,
        RebirthWindow = RebirthWindow,
    }
    
    local function TryRebirth(): boolean
        if not CanRebirth(player) then
            return false
        end

        ApplyRebirth(player)
        NetworkClient.Rebirth.Rebirth.Invoke()
        return true
    end

    local windowScaling = scope:WindowScaling("Rebirth", WindowController.CurrentWindow)

    local rebirthWindow = scope:RebirthWindow {
        Scale = windowScaling.Scale,
        Visible = windowScaling.Visible,

        Level = player.Level.Level,
        Coins = player.Coins.Coins,

        RequiredCoins = RebirthConfig.Costs.Coins,
        RequiredLevel = RebirthConfig.Costs.Level,

        BombGain = RebirthConfig.Rewards.Bombs.Bombs,
        GoldBombGain = RebirthConfig.Rewards.Bombs.GoldBombs,
        NukeGain = RebirthConfig.Rewards.Bombs.Nukes,

        IncomeGain = RebirthConfig.Rewards.IncomePercent,
        SpeedGain = RebirthConfig.Rewards.SpeedPercent,

        RebirthClicked = TryRebirth,

        OnClose = function()
            WindowController.CloseWindow()
        end,
    }

    local function Start()
        local screenGui = Instance.new("ScreenGui")
        screenGui.ResetOnSpawn = false
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        
        rebirthWindow.Parent = screenGui
        screenGui.Parent = player.Player.PlayerGui
    end

    local self: RebirthController = {
        Start = Start,
        TryRebirth = TryRebirth,
    }

    return self
end

return RebirthController
