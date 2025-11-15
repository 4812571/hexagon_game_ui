--!strict
--!native
--!nolint LocalShadow

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)
local Children = Fusion.Children

local EmbossedFrame = require(Client.Interface.EmbossedFrame)
local ButtonFrame = require(Client.Interface.ButtonFrame)
local Icon = require(Client.Interface.Icon)
local Text = require(Client.Interface.Text)
local ProgressBar = require(Client.Interface.ProgressBar)

type Scope<T> = Fusion.Scope<typeof(Fusion) & T>

export type Components = {
    EmbossedFrame: typeof(EmbossedFrame),
    ButtonFrame: typeof(ButtonFrame),
    Icon: typeof(Icon),
    Text: typeof(Text),

    ProgressBar: typeof(ProgressBar),
}

export type QuestCardProps = {
    Size: Fusion.UsedAs<UDim2>?,
    Position: Fusion.UsedAs<UDim2>?,
    AnchorPoint: Fusion.UsedAs<Vector2>?,

    LayoutOrder: Fusion.UsedAs<number>?,

    Icon: Fusion.UsedAs<string>,
    QuestText: Fusion.UsedAs<string>,
    RewardExperience: Fusion.UsedAs<number>,
    
    Progress: Fusion.UsedAs<number>,
    RequiredProgress: Fusion.UsedAs<number>,

    OnClaim: () -> (),
}

local function QuestCard<U>(scope: Scope<U>, props: QuestCardProps)
    local scope: Scope<Components> = scope:innerScope {
        EmbossedFrame = EmbossedFrame,
        ButtonFrame = ButtonFrame,
        Icon = Icon,
        Text = Text,

        ProgressBar = ProgressBar,
    }

    local claimCount = scope:Computed(function(use)
        return (use(props.Progress) :: number) // (use(props.RequiredProgress) :: number)
    end)

    local progress = scope:Computed(function(use)
        return math.clamp((use(props.Progress) :: number) / (use(props.RequiredProgress) :: number), 0, 1)
    end)

    return scope:New "Frame" {
        Size = props.Size,
        Position = props.Position,
        AnchorPoint = props.AnchorPoint,
        BackgroundTransparency = 1,

        LayoutOrder = props.LayoutOrder,

        [Children] = {
            scope:New "UIPadding" {
                PaddingTop = UDim.new(0, 12),
                PaddingLeft = UDim.new(0, 12),
                PaddingRight = UDim.new(0, 24),
            },

            scope:EmbossedFrame {
                Color = Color3.fromRGB(81, 115, 226),

                Size = UDim2.fromScale(1, 1),
                Position = UDim2.fromScale(0.5, 0.5),
                AnchorPoint = Vector2.new(0.5, 0.5),

                StrokeThickness = 3.5,

                Children = scope:New "Frame" {
                    Name = "QuestCardContent",
                    Size = UDim2.fromScale(1, 1),
                    BackgroundTransparency = 1,

                    [Children] = {
                        scope:New "UIListLayout" {
                            FillDirection = Enum.FillDirection.Horizontal,
                            HorizontalFlex = Enum.UIFlexAlignment.Fill,
                            VerticalAlignment = Enum.VerticalAlignment.Center,
                        },

                        scope:New "Frame" {
                            Size = UDim2.fromScale(0.55, 1),
                            BackgroundTransparency = 1,

                            [Children] = {
                                scope:New "UIFlexItem" {
                                    FlexMode = Enum.UIFlexMode.None,
                                },

                                scope:New "UIListLayout" {
                                    FillDirection = Enum.FillDirection.Horizontal,
                                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                                    VerticalAlignment = Enum.VerticalAlignment.Center,
                                    HorizontalFlex = Enum.UIFlexAlignment.Fill,
                                    Padding = UDim.new(0, 15),
                                },

                                scope:Icon {
                                    Icon = props.Icon,
                                    Size = UDim2.fromScale(0.82, 0.82),

                                    Children = scope:New "UIFlexItem" {
                                        FlexMode = Enum.UIFlexMode.None,
                                    }
                                },

                                scope:New "Frame" {
                                    BackgroundTransparency = 1,
                                    AutomaticSize = Enum.AutomaticSize.Y,

                                    [Children] = {
                                        scope:New "UIFlexItem" {
                                            FlexMode = Enum.UIFlexMode.Fill,
                                        },

                                        scope:New "UIListLayout" {
                                            SortOrder = Enum.SortOrder.LayoutOrder,
                                            FillDirection = Enum.FillDirection.Vertical,
                                            HorizontalAlignment = Enum.HorizontalAlignment.Center,
                                            VerticalAlignment = Enum.VerticalAlignment.Center,

                                            Padding = UDim.new(0, 5),
                                        },

                                        scope:Text {
                                            LayoutOrder = 1,

                                            Size = UDim2.fromScale(1, 0.45),
                                            Text = props.QuestText,
                                            TextSize = 22,
                                            TextXAlignment = Enum.TextXAlignment.Left,
                                            StrokeSize = 2.0,
                                        },

                                        scope:ProgressBar {
                                            LayoutOrder = 2,

                                            Size = UDim2.fromScale(1, 0.3),
                                            TextSize = 16,

                                            BackgroundColor = Color3.fromRGB(0, 0, 0),

                                            BarAlpha = scope:Spring(progress, 25),

                                            BarColor = scope:Computed(function(use)
                                                return if use(props.Progress) > 0 then Color3.fromRGB(72, 255, 0) else Color3.new(0, 0, 0)
                                            end),
                                            
                                            Text = scope:Computed(function(use)
                                                return `{use(props.Progress)} / {use(props.RequiredProgress)}`
                                            end),
                                        },
                                    },
                                },
                            },
                        },

                        scope:New "Frame" {
                            BackgroundTransparency = 1,
                            Size = UDim2.fromScale(0, 1),

                            [Children] = {
                                scope:New "UIFlexItem" {
                                    FlexMode = Enum.UIFlexMode.Fill,
                                },

                                scope:New "UIListLayout" {
                                    SortOrder = Enum.SortOrder.LayoutOrder,
                                    FillDirection = Enum.FillDirection.Horizontal,
                                    VerticalAlignment = Enum.VerticalAlignment.Center,
                                    HorizontalFlex = Enum.UIFlexAlignment.SpaceEvenly,
                                    Padding = UDim.new(0, 10),
                                },

                                scope:Text {
                                    Size = UDim2.fromScale(0.25, 0.4),
                                    
                                    Text = scope:Computed(function(use)
                                        return `+{use(props.RewardExperience)} XP`
                                    end),
                                    
                                    TextSize = 32,
                                    LayoutOrder = 2,
                                    StrokeSize = 2.5,
                                },

                                scope:Computed(function(use): Fusion.Child
                                    local claimCount = use(claimCount)

                                    if claimCount == 0 then
                                        return {}
                                    end

                                    return scope:New "Frame" {
                                        Size = UDim2.fromScale(0.50, 0.45),
                                        LayoutOrder = 2,
                                        BackgroundTransparency = 1,

                                        [Children] = scope:ButtonFrame {
                                            Size = UDim2.fromScale(1, 1),
                                            Position = UDim2.fromScale(0.5, 0.5),
                                            AnchorPoint = Vector2.new(0.5, 0.5),

                                            BackgroundTransparency = 1,

                                            Scaling = {
                                                Idle = 1.0,
                                                Hover = 1.05,
                                                Press = 0.95,
                                            },

                                            Activated = props.OnClaim,

                                            Children = scope:New "Frame" {
                                                BackgroundTransparency = 1,
                                                Size = UDim2.fromScale(1, 1),
                                                Position = UDim2.fromScale(0.5, 0.5),
                                                AnchorPoint = Vector2.new(0.5, 0.5),

                                                [Children] = {
                                                    scope:EmbossedFrame {
                                                        Size = UDim2.fromScale(1, 1),
                                                        Color = Color3.fromRGB(0, 255, 0),
                                                        StrokeThickness = 2.5,
                                                        CornerRadius = UDim.new(0, 15),
                                                    },

                                                    scope:Text {
                                                        Text = scope:Computed(function(use)
                                                            return if use(claimCount) == 1 then "Claim" else `Claim x{use(claimCount)}`
                                                        end),

                                                        TextSize = 26,
                                                        StrokeSize = 2.5,
                                                    },
                                                },
                                            },
                                        },
                                    }
                                end),
                            } :: {Fusion.Child},
                        },
                    }
                }
            }
        }
    }
end

return QuestCard