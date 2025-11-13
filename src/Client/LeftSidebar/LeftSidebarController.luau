--!strict
--!native
--!nolint LocalShadow

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)
type Scope = Fusion.Scope<typeof(Fusion)>

local ClientPlayer = require(Client.Player.ClientPlayer)
type ClientPlayer = ClientPlayer.ClientPlayer

local WindowController = require(Client.Window.WindowController)

local LeftSidebar = require(Client.LeftSidebar.LeftSidebar)

export type Controllers = {
    WindowController: WindowController.WindowController,
}

export type LeftSidebarController = {
    Start: () -> (),
}

local function LeftSidebarController(scope: Scope, player: ClientPlayer, controllers: Controllers): LeftSidebarController
    local WindowController = controllers.WindowController
    
    local scope = scope:innerScope {
        LeftSidebar = LeftSidebar,
    }

    local leftSidebar = scope:LeftSidebar {
        Scale = 0.40,

        Position = UDim2.fromScale(0.005, 0.5),
        AnchorPoint = Vector2.new(0, 0.5),

        Revives = player.Revives.Revives,

        LevelButton = {
            Activated = function()
                WindowController.ToggleWindow("Level")
            end,

            IsNew = false,
        },

        QuestsButton = {
            Activated = function()
                WindowController.ToggleWindow("Quests")
            end,

            IsNew = false,
        },

        RebirthButton = {
            Activated = function()
                WindowController.ToggleWindow("Rebirth")
            end,

            IsNew = false,
        },

        TrailsButton = {
            Activated = function()
                WindowController.ToggleWindow("Trails")
            end,

            IsNew = false,
        },

        SkinsButton = {
            Activated = function()
                WindowController.ToggleWindow("Skins")
            end,

            IsNew = false,
        },

        TrollButton = {
            Activated = function()
                print("Troll Button Activated")
            end,

            IsNew = false,
        },
    }

    local function Start()
        local screenGui = Instance.new("ScreenGui")
        screenGui.ResetOnSpawn = false
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        
        leftSidebar.Parent = screenGui
        screenGui.Parent = player.Player.PlayerGui
    end

    local self = {
        Start = Start
    }

    return self
end

return LeftSidebarController