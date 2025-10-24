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

local LevelRewards = require(Common.Level.LevelRewards)
type LevelReward = LevelRewards.LevelReward

local Window = require(Client.Interface.Window)
local Icon = require(Client.Interface.Icon)
local ProgressBar = require(Client.Interface.ProgressBar)
local LevelRewardCard = require(Client.Level.LevelRewardCard)
local InteractionFrame = require(Client.Interface.InteractionFrame)
local EmbossedFrame = require(Client.Interface.EmbossedFrame)
local IconText = require(Client.Interface.IconText)

type Scope<T> = Fusion.Scope<typeof(Fusion) & T>

type Components = {
    Window: typeof(Window),
    Icon: typeof(Icon),
    IconText: typeof(IconText),
    ProgressBar: typeof(ProgressBar),
    LevelRewardCard: typeof(LevelRewardCard),
    InteractionFrame: typeof(InteractionFrame),
    EmbossedFrame: typeof(EmbossedFrame),
}

export type ClaimState = "NotAvailable" | "Available" | "Claimed"

export type LevelRewardEntry = {
    Level: number,
    Reward: LevelReward,
    ClaimState: Fusion.UsedAs<ClaimState>,
    OnClaim: (() -> ()),
}

export type LevelWindowProps = {
    Scale: Fusion.UsedAs<number>,
    Visible: Fusion.UsedAs<boolean>?,

    Level: Fusion.UsedAs<number>,
    Experience: Fusion.UsedAs<number>,
    ExperienceToNextLevel: Fusion.UsedAs<number>,
    Speed: Fusion.UsedAs<number>,
    Rewards: Fusion.UsedAs<{LevelRewardEntry}>,

    OnClose: () -> (),
}

local function Pluralize(word: string, count: number): string
    return if count == 1 then word else `{word}s`
end

local function LevelWindow<U>(scope: Scope<U>, props: LevelWindowProps)
    local scope: Scope<Components> = scope:innerScope {
        Icon = Icon,
        Window = Window,
        ProgressBar = ProgressBar,
        LevelRewardCard = LevelRewardCard,
        InteractionFrame = InteractionFrame,
        EmbossedFrame = EmbossedFrame,
        IconText = IconText,
    }

    return scope:Window {
        Title = "Level",
        Icon = Icons.UpArrow,
        IconScale = 1.35,

        Visible = props.Visible,
        OnClose = props.OnClose,

        Children = {
            scope:New "UIScale" {
                Scale = props.Scale,
            },

            scope:New "Frame" {
                Size = UDim2.fromScale(0.9, 0.9),
                Position = UDim2.fromScale(0.5, 0.5),
                AnchorPoint = Vector2.new(0.5, 0.5),
                ClipsDescendants = true,

                BackgroundTransparency = 1,

                [Children] = {
                    scope:New "Frame" {
                        Size = UDim2.fromScale(1, 0.20),
                        BackgroundTransparency = 1,
                        LayoutOrder = 1,

                        [Children] = {
                            scope:New "Frame" {
                                Position = UDim2.fromScale(0, 0.5),
                                AnchorPoint = Vector2.new(0, 0.5),
                                Size = UDim2.fromScale(0.4, 1),
                                BackgroundTransparency = 1,
                                
                                [Children] = {
                                    scope:New "UIListLayout" {
                                        FillDirection = Enum.FillDirection.Vertical,
                                        SortOrder = Enum.SortOrder.LayoutOrder,

                                        HorizontalAlignment = Enum.HorizontalAlignment.Center,
                                        VerticalAlignment = Enum.VerticalAlignment.Center,
                                    },

                                    scope:New "TextLabel" {
                                        Size = UDim2.fromScale(1, 0.5),

                                        BackgroundTransparency = 1,
                                        TextColor3 = Color3.fromRGB(255, 255, 255),
                                        Font = Enum.Font.FredokaOne,
                                        TextXAlignment = Enum.TextXAlignment.Left,
                                        TextSize = 24,

                                        [Children] = {
                                            scope:New "UIStroke" {
                                                Thickness = 3,
                                                Color = Color3.fromRGB(0, 0, 0),
                                                LineJoinMode = Enum.LineJoinMode.Miter,
                                            },

                                            scope:New "UIPadding" {
                                                PaddingLeft = UDim.new(0, 10),
                                            },
                                        },

                                        LayoutOrder = 1,

                                        Text = scope:Computed(function(use)
                                            return `Level: {use(props.Level)}`
                                        end),
                                    },

                                    scope:New "TextLabel" {
                                        Size = UDim2.fromScale(1, 0.5),

                                        BackgroundTransparency = 1,
                                        TextColor3 = Color3.fromRGB(255, 255, 255),
                                        Font = Enum.Font.FredokaOne,
                                        TextXAlignment = Enum.TextXAlignment.Left,
                                        TextSize = 24,

                                    
                                        [Children] = {
                                            scope:New "UIStroke" {
                                                Thickness = 3,
                                                Color = Color3.fromRGB(0, 0, 0),
                                                LineJoinMode = Enum.LineJoinMode.Miter,
                                            },

                                            scope:New "UIPadding" {
                                                PaddingLeft = UDim.new(0, 10),
                                            },
                                        },

                                        LayoutOrder = 2,

                                        Text = scope:Computed(function(use)
                                            return `Speed: {use(props.Speed)}`
                                        end),
                                    },
                                },
                            },

                            scope:ProgressBar {
                                Size = UDim2.fromScale(0.6, 0.3),
                                Position = UDim2.fromScale(0.30, 0.91),
                                AnchorPoint = Vector2.new(0, 1),

                                BackgroundColor = Color3.fromRGB(0, 0, 0),
                                BarColor = Color3.fromRGB(0, 149, 235),

                                Text = scope:Computed(function(use)
                                    return `{use(props.Experience)} / {use(props.ExperienceToNextLevel)} XP`
                                end),

                                BarAlpha = scope:Computed(function(use)
                                    return (use(props.Experience) :: number) / (use(props.ExperienceToNextLevel) :: number)
                                end),

                                Children = scope:Icon {
                                    Size = UDim2.fromOffset(40, 40),
                                    Position = UDim2.fromScale(1, 0.5),
                                    AnchorPoint = Vector2.new(0.5, 0.5),
                                    Icon = Icons.UpArrow,
                                }
                            }
                        },
                    },

                    scope:New "ScrollingFrame" {
                        Size = UDim2.fromScale(1, 0),
                        Position = UDim2.fromScale(0, 0.7),
                        AnchorPoint = Vector2.new(0, 1),
                        BackgroundTransparency = 1,
                        LayoutOrder = 2,

                        AutomaticSize = Enum.AutomaticSize.Y,
                        AutomaticCanvasSize = Enum.AutomaticSize.X,
                        CanvasSize = UDim2.new(0, 0, 0, 0),
                        ScrollingDirection = Enum.ScrollingDirection.X,
                        ScrollBarThickness = 8,
                        VerticalScrollBarInset = Enum.ScrollBarInset.None,
                        HorizontalScrollBarInset = Enum.ScrollBarInset.ScrollBar,

                        [Children] = {
                            scope:New "UIListLayout" {
                                FillDirection = Enum.FillDirection.Horizontal,
                                SortOrder = Enum.SortOrder.LayoutOrder,

                                HorizontalAlignment = Enum.HorizontalAlignment.Left,
                                VerticalAlignment = Enum.VerticalAlignment.Center,

                                Padding = UDim.new(0, 10),
                            },

                            scope:New "UIPadding" {
                                PaddingLeft = UDim.new(0, 10),
                                PaddingRight = UDim.new(0, 10),
                                PaddingTop = UDim.new(0, 10),
                                PaddingBottom = UDim.new(0, 10),
                            },

                            scope:ForValues(props.Rewards, function(use, scope: Scope<Components>, reward: LevelRewardEntry)
                                return scope:LevelRewardCard {
                                    Size = UDim2.fromOffset(120, 162),

                                    Color = scope:Computed(function(use)
                                        if use(reward.ClaimState) == "Claimed" then
                                            return Color3.fromRGB(115, 223, 26)
                                        end

                                        if use(reward.ClaimState) == "Available" then
                                            return Color3.fromRGB(117, 154, 221)
                                        end

                                        if use(reward.ClaimState) == "NotAvailable" then
                                            return Color3.fromRGB(245, 188, 3)
                                        end

                                        error("Invalid claim state")
                                    end),

                                    LevelText = `Level {reward.Level}`,

                                    RewardIcon = scope:Computed(function(use)
                                        if reward.Reward.Type == "Bomb" then
                                            if reward.Reward.BombType == "Bomb" then
                                                return Icons.Bomb
                                            end

                                            if reward.Reward.BombType == "GoldBomb" then
                                                return Icons.GoldenBomb
                                            end

                                            if reward.Reward.BombType == "Nuke" then
                                                return Icons.Rocket
                                            end
                                        end

                                        if reward.Reward.Type == "Coin" then
                                            return Icons.Coin
                                        end

                                        if reward.Reward.Type == "Speed" then
                                            return Icons.Shoe
                                        end

                                        if reward.Reward.Type == "Spin" then
                                            return Icons.Wheel
                                        end

                                        if reward.Reward.Type == "Income" then
                                            return Icons.Coin
                                        end

                                        error("Unknown reward type")
                                    end),

                                    StatusIcon = scope:Computed(function(use): string?
                                        if use(reward.ClaimState) == "NotAvailable" then
                                            return Icons.Lock
                                        end

                                        if use(reward.ClaimState) == "Claimed" then
                                            return Icons.Check
                                        end

                                        return nil
                                    end),
                                    
                                    RewardText = scope:Computed(function(use)
                                        if reward.Reward.Type == "Bomb" then
                                            if reward.Reward.BombType == "Bomb" then
                                                return `+{reward.Reward.Amount} {Pluralize("Bomb", reward.Reward.Amount)}`
                                            end

                                            if reward.Reward.BombType == "GoldBomb" then
                                                return `+{reward.Reward.Amount} {Pluralize("Gold Bomb", reward.Reward.Amount)}`
                                            end

                                            if reward.Reward.BombType == "Nuke" then
                                                return `+{reward.Reward.Amount} {Pluralize("Nuke", reward.Reward.Amount)}`
                                            end
                                        end

                                        if reward.Reward.Type == "Coin" then
                                            return `+{reward.Reward.Amount} {Pluralize("Coin", reward.Reward.Amount)}`
                                        end

                                        if reward.Reward.Type == "Speed" then
                                            return `+{reward.Reward.Percent}% Speed`
                                        end

                                        if reward.Reward.Type == "Spin" then
                                            return `+{reward.Reward.Amount} {Pluralize("Spin", reward.Reward.Amount)}`
                                        end

                                        if reward.Reward.Type == "Income" then
                                            return `+{reward.Reward.Percent}% Income`
                                        end

                                        error("Unknown reward type")
                                    end),

                                    ClaimColor = Color3.fromRGB(0, 149, 235),

                                    OnClaim = scope:Computed(function(use): (() -> ())?
                                        if use(reward.ClaimState) ~= "Available" then
                                            return nil
                                        end

                                        return reward.OnClaim
                                    end),
                                }
                            end)  
                        } :: {Fusion.Child}
                    },

                    scope:New "Frame" {
                        Size = UDim2.fromScale(1, 0.20),
                        Position = UDim2.fromScale(0.5, 0.9),
                        AnchorPoint = Vector2.new(0.5, 0.5),

                        LayoutOrder = 3,

                        [Children] = {
                            scope:New "UIListLayout" { 
                                FillDirection = Enum.FillDirection.Horizontal,
                                VerticalAlignment = Enum.VerticalAlignment.Center,
                                HorizontalFlex = Enum.UIFlexAlignment.SpaceAround,
                            },

                            scope:InteractionFrame {
                                Size = UDim2.fromScale(0.35, 0.7),
                                BackgroundTransparency = 1,

                                Children = {
                                    scope:EmbossedFrame {
                                        Size = UDim2.fromScale(1, 1),
                                        Color = Color3.fromRGB(30, 255, 0),
                                        CornerRadius = UDim.new(0, 20),
                                        StrokeThickness = 3,

                                        Children = scope:New "Frame" {
                                            Size = UDim2.fromScale(1, 1),
                                            BackgroundTransparency = 1,

                                            [Children] = {
                                                scope:New "UIPadding" {
                                                    PaddingLeft = UDim.new(0, 10),
                                                    PaddingRight = UDim.new(0, 10),
                                                    PaddingTop = UDim.new(0, 10),
                                                    PaddingBottom = UDim.new(0, 10),
                                                },

                                                scope:New "TextLabel" {
                                                    Size = UDim2.fromScale(0.35, 1),
                                                    Position = UDim2.fromScale(0, 0.5),
                                                    AnchorPoint = Vector2.new(0, 0.5),

                                                    BackgroundTransparency = 1,
                                                    TextColor3 = Color3.fromRGB(255, 255, 255),
                                                    Font = Enum.Font.FredokaOne,
                                                    TextSize = 30,

                                                    Text = "Skip",

                                                    [Children] = {
                                                        scope:New "UIStroke" {
                                                            Thickness = 2,
                                                            Color = Color3.fromRGB(0, 0, 0),
                                                        },
                                                    },
                                                },

                                                scope:IconText {
                                                    Size = UDim2.fromScale(0.6, 1),
                                                    Position = UDim2.fromScale(1, 0.5),
                                                    AnchorPoint = Vector2.new(1, 0.5),

                                                    Icon = Icons.Coin,
                                                    IconScale = 1.4,

                                                    Text = "5,000,000",
                                                    TextSize = 15.5,
                                                    IconSide = "Right",
                                                    TextStrokeThickness = 1,
                                                }
                                            }
                                        },
                                    },
                                }
                            },

                            scope:InteractionFrame {
                                Size = UDim2.fromScale(0.35, 0.7),
                                BackgroundTransparency = 1,

                                Children = {
                                    scope:EmbossedFrame {
                                        Size = UDim2.fromScale(1, 1),
                                        Color = Color3.fromRGB(255, 0, 0),
                                        CornerRadius = UDim.new(0, 20),
                                        StrokeThickness = 3,

                                        Children = scope:New "Frame" {
                                            Size = UDim2.fromScale(1, 1),
                                            BackgroundTransparency = 1,

                                            [Children] = {
                                                scope:New "UIPadding" {
                                                    PaddingLeft = UDim.new(0, 10),
                                                    PaddingRight = UDim.new(0, 10),
                                                    PaddingTop = UDim.new(0, 10),
                                                    PaddingBottom = UDim.new(0, 10),
                                                },

                                                scope:New "TextLabel" {
                                                    Size = UDim2.fromScale(0.35, 1),
                                                    Position = UDim2.fromScale(0, 0.5),
                                                    AnchorPoint = Vector2.new(0, 0.5),

                                                    BackgroundTransparency = 1,
                                                    TextColor3 = Color3.fromRGB(255, 255, 255),
                                                    Font = Enum.Font.FredokaOne,
                                                    TextSize = 30,

                                                    Text = "Skip",

                                                    [Children] = {
                                                        scope:New "UIStroke" {
                                                            Thickness = 2,
                                                            Color = Color3.fromRGB(0, 0, 0),
                                                        },
                                                    },
                                                },

                                                scope:IconText {
                                                    Size = UDim2.fromScale(0.6, 1),
                                                    Position = UDim2.fromScale(1, 0.5),
                                                    AnchorPoint = Vector2.new(1, 0.5),

                                                    Icon = Icons.Robux,
                                                    IconScale = 1.4,

                                                    Text = "5,000,000",
                                                    TextSize = 15.5,
                                                    IconSide = "Right",
                                                    TextStrokeThickness = 1,
                                                }
                                            }
                                        },
                                    },
                                }
                            },
                        }
                    },
                }
            }
        }
    }
end

return LevelWindow
