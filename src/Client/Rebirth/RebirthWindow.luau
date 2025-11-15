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

local Text = require(Client.Interface.Text)
local Window = require(Client.Interface.Window)
local EmbossedFrame = require(Client.Interface.EmbossedFrame)
local ButtonFrame = require(Client.Interface.ButtonFrame)
local Icon = require(Client.Interface.Icon)

local RebirthRewardCard = require(Client.Rebirth.RebirthRewardCard)
local RebirthBar = require(Client.Rebirth.RebirthBar)

type Scope<T> = Fusion.Scope<typeof(Fusion) & T>

type Components = {
    Text: typeof(Text),
    Window: typeof(Window),
    EmbossedFrame: typeof(EmbossedFrame),
    ButtonFrame: typeof(ButtonFrame),
    Icon: typeof(Icon),

    RebirthRewardCard: typeof(RebirthRewardCard),
    RebirthBar: typeof(RebirthBar),
}

export type RebirthWindowProps = {
    Scale: Fusion.UsedAs<number>,
    Visible: Fusion.UsedAs<boolean>,

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
        Text = Text,
        Window = Window,
        EmbossedFrame = EmbossedFrame,
        ButtonFrame = ButtonFrame,
        Icon = Icon,

        RebirthRewardCard = RebirthRewardCard,
        RebirthBar = RebirthBar,
    }

    return scope:Window {
        Title = "Rebirth",
        Icon = Icons.Rebirth,
        Visible = props.Visible,
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

                            scope:Text {
                                Size = UDim2.fromScale(1.0, 0),
                                AutomaticSize = Enum.AutomaticSize.Y,
                                Text = "Resets: Coins, Levels, Speed",
                                TextSize = 32,
                                TextColor3 = Color3.fromRGB(255, 1, 1),
                                LayoutOrder = 1,
                                StrokeSize = 2.0,
                            },

                            scope:Text {
                                Size = UDim2.fromScale(1, 0),
                                AutomaticSize = Enum.AutomaticSize.Y,
                                Text = scope:Computed(function(use)
                                    return `+{use(props.SpeedGain)}% Permanent Speed, +{use(props.IncomeGain)}% Income, Bomb Pack`
                                end),
                                TextSize = 32,
                                TextColor3 = Color3.fromRGB(255, 204, 0),
                                LayoutOrder = 2,
                                StrokeSize = 2.0,
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

                            scope:ButtonFrame {
                                AnchorPoint = Vector2.new(0.5, 0.5),
                                Position = UDim2.fromScale(0.5, 0.5),
                                Size = UDim2.fromOffset(320, 70),

                                Activated = props.RebirthClicked,

                                Scaling = {
                                    Idle = 1.0,
                                    Hover = 1.05,
                                    Press = 0.9,
                                },

                                Children = scope:EmbossedFrame {
                                    Size = UDim2.fromScale(1, 1),
                                    Color = Color3.fromRGB(72, 255, 0),
                                    CornerRadius = UDim.new(0, 32),
                                    StrokeThickness = 4,

                                    Children = {
                                        scope:Text {
                                            Text = "Rebirth!",
                                            TextSize = 58,
                                            StrokeSize = 3.0,
                                        },

                                        scope:Icon {
                                            Icon = Icons.Rebirth,
                                            IconScale = 1.2,
                                            Size = UDim2.fromScale(1, 1),
                                            Position = UDim2.fromScale(0.05, 0.5),
                                            AnchorPoint = Vector2.new(0.5, 0.5),
                                        },
                                    },
                                },
                            },
                        },
                    }
                },
            }
        }
    }
end

return RebirthWindow
