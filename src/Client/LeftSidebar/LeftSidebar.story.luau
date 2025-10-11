local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)
local Children = Fusion.Children

local Icons = require(Common.Icons)

local SidebarSquareButton = require(Client.LeftSidebar.SidebarSquareButton)

return function(target: Instance)
    local scope = Fusion.scoped(Fusion, {
        SidebarSquareButton = SidebarSquareButton,
    })

    local levelButton = scope:SidebarSquareButton {
        Name = "LevelButton",
        Size = UDim2.fromOffset(150, 150),

        Text = "Level",
        Icon = Icons.UpArrow,
        Color = Color3.new(0.933333, 0.203922, 0.203922),
        IsNew = true,
    }

    local questsButton = scope:SidebarSquareButton {
        Name = "QuestsButton",
        Size = UDim2.fromOffset(150, 150),
        Position = UDim2.fromOffset(0, 175),

        Text = "Quests",
        Icon = Icons.Scroll,
        Color = Color3.fromRGB(255, 165, 0),
        IsNew = false,
    }

    local rebirthButton = scope:SidebarSquareButton {
        Name = "RebirthButton",
        Size = UDim2.fromOffset(150, 150),
        Position = UDim2.fromOffset(0, 350),

        Text = "Rebirth",
        Icon = Icons.Rebirth,
        Color = Color3.fromRGB(242, 98, 110),
        IsNew = true,
    }

    local trailsButton = scope:SidebarSquareButton {
        Name = "TrailsButton",
        Size = UDim2.fromOffset(150, 150),
        Position = UDim2.fromOffset(0, 525),

        Text = "Trails",
        Icon = Icons.Aura,
        Color = Color3.fromRGB(136, 128, 221),
        IsNew = false,
    }

    local skinsButton = scope:SidebarSquareButton {
        Name = "SkinsButton",
        Size = UDim2.fromOffset(150, 150),
        Position = UDim2.fromOffset(0, 700),

        Text = "Skins",
        Icon = Icons.Pencil,
        Color = Color3.fromRGB(101, 246, 24),
        IsNew = false,
    }

    local trollButton = scope:SidebarSquareButton {
        Name = "TrollButton",
        Size = UDim2.fromOffset(150, 150),
        Position = UDim2.fromOffset(0, 875),

        Text = "Troll",
        Icon = Icons.Devil,
        Color = Color3.fromRGB(154, 9, 227),
        IsNew = true,
    }

    local container = scope:New "Frame" {
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),

        AutomaticSize = Enum.AutomaticSize.XY,
        BackgroundTransparency = 1,

        [Children] = {
            scope:New "UIListLayout" {
                Padding = UDim.new(0, 25),
                FillDirection = Enum.FillDirection.Vertical,
            },

            scope:New "Frame" {
                AutomaticSize = Enum.AutomaticSize.XY,
                BackgroundTransparency = 1,

                [Children] = {
                    scope:New "UIListLayout" {
                        Padding = UDim.new(0, 25),
                        FillDirection = Enum.FillDirection.Horizontal,
                    },

                    levelButton,
                    questsButton,
                    rebirthButton,
                },
            },

            scope:New "Frame" {
                AutomaticSize = Enum.AutomaticSize.XY,
                BackgroundTransparency = 1,

                [Children] = {
                    scope:New "UIListLayout" {
                        Padding = UDim.new(0, 25),
                        FillDirection = Enum.FillDirection.Horizontal,
                    },

                    trailsButton,
                    skinsButton,
                    trollButton,
                }
            },
        },
    }

    container.Parent = target

    return function()
        scope:doCleanup()
    end
end