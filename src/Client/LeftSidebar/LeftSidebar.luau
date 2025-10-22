--!strict
--!native
--!nolint LocalShadow

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)
local Children = Fusion.Children

local Icons = require(Common.Icons)

local GlobalScale = require(Client.Interface.GlobalScale)
local SidebarSquareButton = require(Client.LeftSidebar.SidebarSquareButton)
local LeftSidebarRevives = require(Client.LeftSidebar.LeftSidebarRevives)

type Scope<T> = Fusion.Scope<typeof(Fusion) & T>

type Components = {
    GlobalScale: typeof(GlobalScale),
    SidebarSquareButton: typeof(SidebarSquareButton),
    LeftSidebarRevives: typeof(LeftSidebarRevives),
}

type ButtonProps = {
    IsNew: Fusion.UsedAs<boolean>,
    Activated: () -> (),
}

type LeftSidebarProps = {
    Scale: Fusion.UsedAs<number>,

    Position: Fusion.UsedAs<UDim2>?,
    AnchorPoint: Fusion.UsedAs<Vector2>?,

    Revives: Fusion.UsedAs<number>,

    LevelButton: ButtonProps,
    QuestsButton: ButtonProps,
    RebirthButton: ButtonProps,
    TrailsButton: ButtonProps,
    SkinsButton: ButtonProps,
    TrollButton: ButtonProps,
}

local function LeftSidebar<U>(scope: Scope<U>, props: LeftSidebarProps)
    local scope: Scope<Components> = scope:innerScope {
        GlobalScale = GlobalScale,
        SidebarSquareButton = SidebarSquareButton,
        LeftSidebarRevives = LeftSidebarRevives,
    }

    local levelButton = scope:SidebarSquareButton {
        Name = "LevelButton",
        Size = UDim2.fromOffset(150, 150),

        Text = "Level",
        Icon = Icons.UpArrow,
        Color = Color3.new(0.933333, 0.203922, 0.203922),
        IsNew = props.LevelButton.IsNew,
        Activated = props.LevelButton.Activated,
    }

    local questsButton = scope:SidebarSquareButton {
        Name = "QuestsButton",
        Size = UDim2.fromOffset(150, 150),
        Position = UDim2.fromOffset(0, 175),

        Text = "Quests",
        Icon = Icons.Scroll,
        Color = Color3.fromRGB(255, 165, 0),
        IsNew = props.QuestsButton.IsNew,
        Activated = props.QuestsButton.Activated,
    }

    local rebirthButton = scope:SidebarSquareButton {
        Name = "RebirthButton",
        Size = UDim2.fromOffset(150, 150),
        Position = UDim2.fromOffset(0, 350),

        Text = "Rebirth",
        Icon = Icons.Rebirth,
        Color = Color3.fromRGB(242, 98, 110),
        IsNew = props.RebirthButton.IsNew,
        Activated = props.RebirthButton.Activated,
    }

    local trailsButton = scope:SidebarSquareButton {
        Name = "TrailsButton",
        Size = UDim2.fromOffset(150, 150),
        Position = UDim2.fromOffset(0, 525),

        Text = "Trails",
        Icon = Icons.Aura,
        Color = Color3.fromRGB(136, 128, 221),
        IsNew = props.TrailsButton.IsNew,
        Activated = props.TrailsButton.Activated,
    }

    local skinsButton = scope:SidebarSquareButton {
        Name = "SkinsButton",
        Size = UDim2.fromOffset(150, 150),
        Position = UDim2.fromOffset(0, 700),

        Text = "Skins",
        Icon = Icons.Pencil,
        Color = Color3.fromRGB(101, 246, 24),
        IsNew = props.SkinsButton.IsNew,
        Activated = props.SkinsButton.Activated,
    }

    local trollButton = scope:SidebarSquareButton {
        Name = "TrollButton",
        Size = UDim2.fromOffset(150, 150),
        Position = UDim2.fromOffset(0, 875),

        Text = "Troll",
        Icon = Icons.Devil,
        Color = Color3.fromRGB(154, 9, 227),
        IsNew = props.TrollButton.IsNew,
        Activated = props.TrollButton.Activated,
    }

    local globalScale = scope:GlobalScale()

    return scope:New "Frame" {
        Position = props.Position,
        AnchorPoint = props.AnchorPoint,

        AutomaticSize = Enum.AutomaticSize.XY,
        BackgroundTransparency = 1,

        [Children] = {
            scope:New "UIListLayout" {
                Padding = UDim.new(0, 25),
                FillDirection = Enum.FillDirection.Vertical,
            },

            scope:New "UIScale" {
                Scale = scope:Computed(function(use)
                    return (use(props.Scale) :: number) * use(globalScale)
                end),
            },

            scope:New "Frame" {
                LayoutOrder = 1,
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
                LayoutOrder = 2,
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

            scope:LeftSidebarRevives {
                LayoutOrder = 3,
                Size = UDim2.fromOffset(0, 80),
                Position = UDim2.fromOffset(0, -100),

                Revives = 3,
            },
        },
    }
end

return LeftSidebar