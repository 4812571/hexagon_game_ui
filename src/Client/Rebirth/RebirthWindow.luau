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

local Window = require(Client.Interface.Window)
local EmbossedFrame = require(Client.Interface.EmbossedFrame)
local InteractionFrame = require(Client.Interface.InteractionFrame)
local Icon = require(Client.Interface.Icon)
local Text = require(Client.Interface.Text)

local RebirthRewardCard = require(Client.Rebirth.RebirthRewardCard)
local RebirthBar = require(Client.Rebirth.RebirthBar)

type Scope<T> = Fusion.Scope<typeof(Fusion) & T>

type Components = {
    Window: typeof(Window),
    EmbossedFrame: typeof(EmbossedFrame),
    InteractionFrame: typeof(InteractionFrame),
    Icon: typeof(Icon),
    Text: typeof(Text),

    RebirthRewardCard: typeof(RebirthRewardCard),
    RebirthBar: typeof(RebirthBar),
}

export type RebirthWindowProps = {
    Scale: Fusion.UsedAs<number>,

    SpeedGain: Fusion.UsedAs<number>,
    IncomeGain: Fusion.UsedAs<number>,

    BombGain: Fusion.UsedAs<number>,
    GoldBombGain: Fusion.UsedAs<number>,
    NukeGain: Fusion.UsedAs<number>,

    Level: Fusion.UsedAs<number>,
    RequiredLevel: Fusion.UsedAs<number>,

    Coins: Fusion.UsedAs<number>,
    RequiredCoins: Fusion.UsedAs<number>,

    RebirthClicked: () -> (),
    OnClose: () -> (),
}

local CARD_SIZE = UDim2.fromOffset(132, 132)

local function CommaFormatNumber(number: number): string
    local str = tostring(number)
    local result = ""
    local count = 0

    for i = #str, 1, -1 do
        result = str:sub(i, i) .. result
        count += 1
        if count % 3 == 0 and i > 1 then
            result = "," .. result
        end
    end

    return result
end

local function RebirthWindow<U>(scope: Scope<U>, props: RebirthWindowProps)
    local scope: Scope<Components> = scope:innerScope {
        Window = Window,
        EmbossedFrame = EmbossedFrame,
        InteractionFrame = InteractionFrame,
        Icon = Icon,
        Text = Text,

        RebirthRewardCard = RebirthRewardCard,
        RebirthBar = RebirthBar,
    }

    local buttonState = scope:Value(Enum.GuiState.NonInteractable)

    local buttonScale = scope:Computed(function(use)
        if use(buttonState) == Enum.GuiState.Press then
            return 0.9
        end

        if use(buttonState) == Enum.GuiState.Hover then
            return 1.05
        end

        return 1.0
    end)

    return scope:Window {
        Title = "Rebirth",
        Icon = Icons.Rebirth,
        IconScale = 1.35,

        OnClose = props.OnClose,

        Children = {
            scope:New "UIScale" {
                Scale = props.Scale,
            },

            scope:New "Frame" {
                Size = UDim2.fromScale(0.8, 0.9),
                Position = UDim2.fromScale(0.5, 0.5),
                AnchorPoint = Vector2.new(0.5, 0.5),

                BackgroundTransparency = 1,
            
                [Children] = {
                    scope:New "UIListLayout" {
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        FillDirection = Enum.FillDirection.Vertical,
                        VerticalAlignment = Enum.VerticalAlignment.Top,
                        HorizontalAlignment = Enum.HorizontalAlignment.Center,
                        Padding = UDim.new(0, 20),
                    },

                    scope:New "Frame" {
                        Size = UDim2.fromScale(1, 0),
                        AutomaticSize = Enum.AutomaticSize.Y,
                        BackgroundTransparency = 1,
                        LayoutOrder = 0,

                        [Children] = {
                            scope:New "UIListLayout" {
                                FillDirection = Enum.FillDirection.Vertical,
                                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                                VerticalAlignment = Enum.VerticalAlignment.Center,
                                SortOrder = Enum.SortOrder.LayoutOrder,
                                Padding = UDim.new(0, 6),
                            },

                            scope:New "TextLabel" {
                                Size = UDim2.fromScale(1.0, 0),
                                AutomaticSize = Enum.AutomaticSize.Y,
                                BackgroundTransparency = 1,
                                Text = "Resets: Coins, Levels, Speed",
                                TextSize = 32,
                                Font = Enum.Font.FredokaOne,
                                TextColor3 = Color3.fromRGB(255, 1, 1),
                                LayoutOrder = 1,
                                TextXAlignment = Enum.TextXAlignment.Center,

                                [Children] = scope:New "UIStroke" {
                                    Thickness = 2,
                                }
                            },

                            scope:New "TextLabel" {
                                Size = UDim2.fromScale(1.0, 0),
                                AutomaticSize = Enum.AutomaticSize.Y,
                                BackgroundTransparency = 1,
                                Text = scope:Computed(function(use)
                                    return `+{use(props.SpeedGain)}% Permanent Speed, +{use(props.IncomeGain)}% Income, Bomb Pack`
                                end),
                                TextSize = 32,
                                Font = Enum.Font.FredokaOne,
                                TextColor3 = Color3.fromRGB(255, 204, 0),
                                LayoutOrder = 2,
                                TextXAlignment = Enum.TextXAlignment.Center,

                                [Children] = scope:New "UIStroke" {
                                    Thickness = 2,
                                }
                            },
                        }
                    },

                    scope:New "Frame" {
                        Size = UDim2.fromScale(1.0, 0),
                        AutomaticSize = Enum.AutomaticSize.Y,
                        BackgroundTransparency = 1,
                        LayoutOrder = 3,
                        
                        [Children] = {
                            scope:New "UIListLayout" {
                                FillDirection = Enum.FillDirection.Horizontal,
                                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                                VerticalAlignment = Enum.VerticalAlignment.Center,
                                SortOrder = Enum.SortOrder.LayoutOrder,
                                Padding = UDim.new(0, 18),
                            },

                            scope:RebirthRewardCard {
                                LayoutOrder = 1,
                                Size = CARD_SIZE,
                                
                                Icon = Icons.Shoe,
                                Color = Color3.fromRGB(255, 80, 80),

                                TopText = "Speed",
                                BottomText = scope:Computed(function(use)
                                    return `+{use(props.SpeedGain)}%`
                                end)
                            },

                            scope:RebirthRewardCard {
                                LayoutOrder = 2,
                                Size = CARD_SIZE,
                                
                                Icon = Icons.Coin,
                                Color = Color3.fromRGB(255, 215, 0),

                                TopText = "Income",
                                BottomText = scope:Computed(function(use)
                                    return `+{use(props.IncomeGain)}%`
                                end)
                            },

                            scope:RebirthRewardCard {
                                LayoutOrder = 3,
                                Size = CARD_SIZE,
                                
                                Icon = Icons.Bomb,
                                Color = Color3.fromRGB(100, 255, 100),

                                TopText = "Bomb",
                                BottomText = scope:Computed(function(use)
                                    return `+{use(props.BombGain)}`
                                end)
                            },

                            scope:RebirthRewardCard {
                                LayoutOrder = 4,
                                Size = CARD_SIZE,
                                
                                Icon = Icons.GoldenBomb,
                                Color = Color3.fromRGB(255, 223, 100),

                                TopText = "Gold Bomb",
                                BottomText = scope:Computed(function(use)
                                    return `+{use(props.GoldBombGain)}`
                                end)
                            },

                            scope:RebirthRewardCard {
                                LayoutOrder = 5,
                                Size = CARD_SIZE,
                                
                                Icon = Icons.Rocket,
                                Color = Color3.fromRGB(0, 0, 0),

                                TopText = "Nuke",
                                BottomText = scope:Computed(function(use)
                                    return `+{use(props.NukeGain)}`
                                end)
                            },
                        },
                    },

                    scope:RebirthBar {
                        LayoutOrder = 6,

                        Size = UDim2.fromScale(1, 0.12),

                        Icon = Icons.UpArrow,
                        Text = scope:Computed(function(use)
                            return `Reach Level {use(props.RequiredLevel)}`
                        end),
                        Progress = props.Level,
                        RequiredProgress = props.RequiredLevel,
                    },

                    scope:RebirthBar {
                        LayoutOrder = 7,

                        Size = UDim2.fromScale(1, 0.12),

                        Icon = Icons.Coin,
                        Text = scope:Computed(function(use)
                            return `Collect {CommaFormatNumber(use(props.RequiredCoins))} Coins`
                        end),
                        Progress = props.Coins,
                        RequiredProgress = props.RequiredCoins,
                    },

                    scope:New "Frame" {
                        LayoutOrder = 8,
                        Size = UDim2.fromScale(1, 0),

                        [Children] = {
                            scope:New "UIFlexItem" {
                                FlexMode = Enum.UIFlexMode.Fill,
                            },

                            scope:InteractionFrame {
                                AnchorPoint = Vector2.new(0.5, 0.5),
                                Position = UDim2.fromScale(0.5, 0.5),
                                Size = UDim2.fromOffset(320, 70),

                                GuiStateChanged = function(newState: Enum.GuiState)
                                    buttonState:set(newState)
                                end,

                                Activated = props.RebirthClicked,

                                Children = {
                                    scope:New "UIScale" {
                                        Scale = scope:Spring(buttonScale, 32),
                                    },

                                    scope:EmbossedFrame {
                                        Size = UDim2.fromScale(1, 1),
                                        Color = Color3.fromRGB(72, 255, 0),
                                        CornerRadius = UDim.new(0, 32),
                                        StrokeThickness = 4,

                                        Children = {
                                            scope:Text {
                                                Size = UDim2.fromScale(1, 1),
                                                Text = "Rebirth!",
                                                TextColor3 = Color3.fromRGB(255, 255, 255),
                                                TextXAlignment = Enum.TextXAlignment.Center,
                                                TextSize = 58,
                                                StrokeSize = 3,
                                            },

                                            scope:Icon {
                                                Icon = Icons.Rebirth,
                                                IconScale = 1.2,
                                                Size = UDim2.fromScale(1, 1),
                                                Position = UDim2.fromScale(0.05, 0.5),
                                                AnchorPoint = Vector2.new(0.5, 0.5),
                                            },
                                        }
                                    },
                                }
                            }
                        },
                    }
                },
            }
        }
    }
end

return RebirthWindow
