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

local Window = require(Client.Interface.Window)
local InteractionFrame = require(Client.Interface.InteractionFrame)
local EmbossedFrame = require(Client.Interface.EmbossedFrame)

local TimedRewardCard = require(Client.TimedRewards.TimedRewardCard)

type Scope<T> = Fusion.Scope<typeof(Fusion) & T>

export type Components = {
    Window: typeof(Window),
    InteractionFrame: typeof(InteractionFrame),
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

local function ButtonScale(state: Enum.GuiState): number
    if state == Enum.GuiState.Hover then
        return 1.1
    end

    if state == Enum.GuiState.Press then
        return 0.9
    end

    return 1.0
end

local function TimedRewardsWindow<U>(scope: Scope<U>, props: TimedRewardsWindowProps)
    local scope: Scope<Components> = scope:innerScope {
        Window = Window,
        InteractionFrame = InteractionFrame,
        EmbossedFrame = EmbossedFrame,

        TimedRewardCard = TimedRewardCard,
    }

    local claimAllState = scope:Value(Enum.GuiState.NonInteractable)
    local speed2State = scope:Value(Enum.GuiState.NonInteractable)
    local speed5State = scope:Value(Enum.GuiState.NonInteractable)

    local claimAllScale = scope:Computed(function(use)
        return ButtonScale(use(claimAllState))
    end)

    local speed2Scale = scope:Computed(function(use)
        return ButtonScale(use(speed2State))
    end)

    local speed5Scale = scope:Computed(function(use)
        return ButtonScale(use(speed5State))
    end)

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

                        scope:New "TextLabel" {
                            Size = UDim2.fromScale(0, 1),
                            Position = UDim2.fromScale(0.925, 0.5),
                            AnchorPoint = Vector2.new(1, 0.5),

                            AutomaticSize = Enum.AutomaticSize.X,

                            BackgroundTransparency = 1,

                            Text = "Rewards reset if you leave!",
                            TextColor3 = Color3.new(1, 1, 1),
                            TextSize = 30,
                            Font = Enum.Font.FredokaOne,
                            [Children] = scope:New "UIStroke" {
                                Thickness = 2,
                            },
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

                        scope:InteractionFrame {
                            Size = UDim2.fromOffset(200, 50),
                            BackgroundTransparency = 1,

                            GuiStateChanged = function(state: Enum.GuiState)
                                claimAllState:set(state)
                            end,

                            Children = scope:EmbossedFrame {
                                Size = UDim2.fromScale(1, 1),
                                Position = UDim2.fromScale(0.5, 0.5),
                                AnchorPoint = Vector2.new(0.5, 0.5),

                                Color = Color3.fromRGB(96, 101, 244),
                                CornerRadius = UDim.new(0, 20),
                                StrokeThickness = 3.0,

                                Children = {
                                    scope:New "UIScale" {
                                        Scale = scope:Spring(claimAllScale, 35),
                                    },

                                    scope:New "TextLabel" {
                                        Size = UDim2.fromScale(1, 1),
                                        Position = UDim2.fromScale(0.5, 0.5),
                                        AnchorPoint = Vector2.new(0.5, 0.5),

                                        BackgroundTransparency = 1,

                                        Text = "Claim All",
                                        TextColor3 = Color3.new(1, 1, 1),
                                        TextSize = 42,
                                        Font = Enum.Font.FredokaOne,

                                        [Children] = scope:New "UIStroke" {
                                            Thickness = 2.8,
                                        }
                                    }
                                },
                            },
                        },

                        scope:InteractionFrame {
                            Size = UDim2.fromOffset(200, 50),
                            BackgroundTransparency = 1,

                            GuiStateChanged = function(state: Enum.GuiState)
                                speed2State:set(state)
                            end,

                            Children = scope:EmbossedFrame {
                                Size = UDim2.fromScale(1, 1),
                                Position = UDim2.fromScale(0.5, 0.5),
                                AnchorPoint = Vector2.new(0.5, 0.5),

                                Color = Color3.fromRGB(244, 96, 101),
                                CornerRadius = UDim.new(0, 20),
                                StrokeThickness = 3.0,

                                Children = {
                                    scope:New "UIScale" {
                                        Scale = scope:Spring(speed2Scale, 35),
                                    },

                                    scope:New "TextLabel" {
                                        Size = UDim2.fromScale(1, 1),
                                        Position = UDim2.fromScale(0.5, 0.5),
                                        AnchorPoint = Vector2.new(0.5, 0.5),

                                        BackgroundTransparency = 1,

                                        Text = "2x Speed",
                                        TextColor3 = Color3.new(1, 1, 1),
                                        TextSize = 42,
                                        Font = Enum.Font.FredokaOne,

                                        [Children] = scope:New "UIStroke" {
                                            Thickness = 2.8,
                                        }
                                    },
                                },
                            },
                        },

                        scope:InteractionFrame {
                            Size = UDim2.fromOffset(200, 50),
                            BackgroundTransparency = 1,

                            GuiStateChanged = function(state: Enum.GuiState)
                                speed5State:set(state)
                            end,

                            Children = scope:EmbossedFrame {
                                Size = UDim2.fromScale(1, 1),
                                Position = UDim2.fromScale(0.5, 0.5),
                                AnchorPoint = Vector2.new(0.5, 0.5),

                                Color = Color3.fromRGB(255, 174, 0),
                                CornerRadius = UDim.new(0, 20),
                                StrokeThickness = 3.0,

                                Children = {
                                    scope:New "UIScale" {
                                        Scale = scope:Spring(speed5Scale, 35),
                                    },

                                    scope:New "TextLabel" {
                                        Size = UDim2.fromScale(1, 1),
                                        Position = UDim2.fromScale(0.5, 0.5),
                                        AnchorPoint = Vector2.new(0.5, 0.5),

                                        BackgroundTransparency = 1,

                                        Text = "5x Speed",
                                        TextColor3 = Color3.new(1, 1, 1),
                                        TextSize = 42,
                                        Font = Enum.Font.FredokaOne,

                                        [Children] = scope:New "UIStroke" {
                                            Thickness = 2.8,
                                        }
                                    },
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
