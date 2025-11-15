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

local TimedRewards = require(Common.TimedRewards.TimedRewards)
type TimedRewardData = TimedRewards.TimedRewardData

local Text = require(Client.Interface.Text)
local Window = require(Client.Interface.Window)
local ButtonFrame = require(Client.Interface.ButtonFrame)
local EmbossedFrame = require(Client.Interface.EmbossedFrame)

local TimedRewardCard = require(Client.TimedRewards.TimedRewardCard)

type Scope<T> = Fusion.Scope<typeof(Fusion) & T>

export type Components = {
    Text: typeof(Text),
    Window: typeof(Window),
    ButtonFrame: typeof(ButtonFrame),
    EmbossedFrame: typeof(EmbossedFrame),

    TimedRewardCard: typeof(TimedRewardCard),
}

export type TimedRewardEntry = {
    RewardData: TimedRewardData,
    Claimed: Fusion.UsedAs<boolean>,
    RemainingTime: Fusion.UsedAs<number>,
}

export type TimedRewardsWindowProps = {
    Rewards: Fusion.UsedAs<{TimedRewardEntry}>,

    OnClaim: (index: number, entry: TimedRewardEntry) -> (),
}

local ROWS = 3
local COLUMNS = 5

local ITEM_SIZE = 130

local ITEM_PADDING_X = 15
local ITEM_PADDING_Y = 20

local function PaddedSize(count: number, size: number, padding: number): number
    return (size + padding) * count - padding
end

local function Range(n: number)
    local arr = {}

    for i = 1, n do
        table.insert(arr, i)
    end

    return arr
end

local function TimedRewardsWindow<U>(scope: Scope<U>, props: TimedRewardsWindowProps)
    local scope: Scope<Components> = scope:innerScope {
        Text = Text,
        Window = Window,
        ButtonFrame = ButtonFrame,
        EmbossedFrame = EmbossedFrame,

        TimedRewardCard = TimedRewardCard,
    }

    return scope:Window {
        Title = "Rewards",
        Icon = Icons.Gift,
        IconScale = 1.65,

        Children = scope:New "Frame" {
            Size = UDim2.fromScale(1, 1),
            Position = UDim2.fromScale(0.5, 0.5),
            AnchorPoint = Vector2.new(0.5, 0.5),
            
            BackgroundTransparency = 1,

            [Children] = {
                scope:New "UIListLayout" {
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    FillDirection = Enum.FillDirection.Vertical,
                    VerticalFlex = Enum.UIFlexAlignment.Fill,
                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                },

                scope:New "Frame" {
                    LayoutOrder = 1,

                    Size = UDim2.fromScale(1, 0.07),
                    BackgroundTransparency = 1,

                    [Children] = {
                        scope:New "UIFlexItem" {
                            FlexMode = Enum.UIFlexMode.None,
                        },

                        scope:Text {
                            Size = UDim2.fromScale(0, 1),
                            Position = UDim2.fromScale(0.925, 0.5),
                            AnchorPoint = Vector2.new(1, 0.5),

                            AutomaticSize = Enum.AutomaticSize.X,

                            BackgroundTransparency = 1,

                            Text = "Rewards reset if you leave!",
                            TextSize = 30,
                            StrokeSize = 2.0,
                        },
                    },
                },

                scope:New "Frame" {
                    LayoutOrder = 2,
                    BackgroundTransparency = 1,

                    Size = UDim2.fromOffset(
                        PaddedSize(COLUMNS, ITEM_SIZE, ITEM_PADDING_X),
                        PaddedSize(ROWS, ITEM_SIZE, ITEM_PADDING_Y)
                    ),

                    [Children] = {
                        scope:New "UIFlexItem" {
                            FlexMode = Enum.UIFlexMode.None,
                        },

                        scope:New "UIGridLayout" {
                            CellSize = UDim2.fromOffset(ITEM_SIZE, ITEM_SIZE),
                            CellPadding = UDim2.fromOffset(ITEM_PADDING_X, ITEM_PADDING_Y),
                        },

                        scope:ForValues(Range(ROWS * COLUMNS), function(use, scope: Scope<Components>, n)
                            return scope:TimedRewardCard {
                                Size = UDim2.fromOffset(140, 140),
                                Position = UDim2.fromScale(0.5, 0.5),
                                AnchorPoint = Vector2.new(0.5, 0.5),

                                Icon = Icons.Coin,
                                Color = Color3.fromRGB(96, 101, 244),
                                TopText = "+5000",
                                BottomText = "22:48",
                                
                                CornerRadius = UDim.new(0.16, 0),
                                Stroke = 3.0,
                            }
                        end),
                    } :: {Fusion.Child},
                },

                scope:New "Frame" {
                    LayoutOrder = 3,

                    Size = UDim2.fromScale(1, 0),
                    BackgroundTransparency = 1,

                    [Children] = {
                        scope:New "UIListLayout" {
                            FillDirection = Enum.FillDirection.Horizontal,
                            HorizontalAlignment = Enum.HorizontalAlignment.Center,
                            VerticalAlignment = Enum.VerticalAlignment.Center,

                            Padding = UDim.new(0, 20),
                        },

                        scope:New "UIPadding" {
                            PaddingTop = UDim.new(0, 15),
                        },

                        scope:ButtonFrame {
                            Size = UDim2.fromOffset(200, 50),
                            BackgroundTransparency = 1,

                            Scaling = {
                                Idle = 1.0,
                                Hover = 1.05,
                                Press = 0.9,
                            },

                            Children = scope:EmbossedFrame {
                                Size = UDim2.fromScale(1, 1),
                                Position = UDim2.fromScale(0.5, 0.5),
                                AnchorPoint = Vector2.new(0.5, 0.5),

                                Color = Color3.fromRGB(96, 101, 244),
                                CornerRadius = UDim.new(0, 20),
                                StrokeThickness = 3.0,

                                Children = scope:Text {
                                    Text = "Claim All",
                                    TextSize = 42,
                                    StrokeSize = 2.8,
                                },
                            },
                        },

                        scope:ButtonFrame {
                            Size = UDim2.fromOffset(200, 50),
                            BackgroundTransparency = 1,

                            Scaling = {
                                Idle = 1.0,
                                Hover = 1.05,
                                Press = 0.9,
                            },

                            Children = scope:EmbossedFrame {
                                Size = UDim2.fromScale(1, 1),
                                Position = UDim2.fromScale(0.5, 0.5),
                                AnchorPoint = Vector2.new(0.5, 0.5),

                                Color = Color3.fromRGB(244, 96, 101),
                                CornerRadius = UDim.new(0, 20),
                                StrokeThickness = 3.0,

                                Children = scope:Text {
                                    Text = "2x Speed",
                                    TextSize = 42,
                                    StrokeSize = 2.8,
                                },
                            },
                        },

                        scope:ButtonFrame {
                            Size = UDim2.fromOffset(200, 50),
                            BackgroundTransparency = 1,

                            Scaling = {
                                Idle = 1.0,
                                Hover = 1.05,
                                Press = 0.9,
                            },

                            Children = scope:EmbossedFrame {
                                Size = UDim2.fromScale(1, 1),
                                Position = UDim2.fromScale(0.5, 0.5),
                                AnchorPoint = Vector2.new(0.5, 0.5),

                                Color = Color3.fromRGB(255, 174, 0),
                                CornerRadius = UDim.new(0, 20),
                                StrokeThickness = 3.0,

                                Children = scope:Text {
                                    Text = "5x Speed",
                                    TextSize = 42,
                                    StrokeSize = 2.8,
                                },
                            },
                        },
                    },
                },
            }
        }      
    }
end

return TimedRewardsWindow
