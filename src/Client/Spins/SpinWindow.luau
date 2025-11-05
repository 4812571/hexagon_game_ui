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

local Stopwatch = require(Common.Util.Stopwatch)

local Text = require(Client.Interface.Text)
local Icon = require(Client.Interface.Icon)
local CloseButton = require(Client.Interface.CloseButton)
local InteractionFrame = require(Client.Interface.InteractionFrame)
local Spinner = require(Client.Spins.Spinner)
local EmbossedFrame = require(Client.Interface.EmbossedFrame)
local IconText = require(Client.Interface.IconText)

type Scope<T> = Fusion.Scope<typeof(Fusion) & T>

local function ButtonSize(scope: Scope<Components>, state: Fusion.UsedAs<Enum.GuiState>)
    return scope:Computed(function(use)
        if use(state) == Enum.GuiState.Hover then
            return 1.1
        end

        if use(state) == Enum.GuiState.Press then
            return 0.95
        end

        return 1.0
    end)
end

export type Components = {
    Text: typeof(Text),
    Stopwatch: typeof(Stopwatch),
    Spinner: typeof(Spinner),
    InteractionFrame: typeof(InteractionFrame),
    Icon: typeof(Icon),
    CloseButton: typeof(CloseButton),
    EmbossedFrame: typeof(EmbossedFrame),
    IconText: typeof(IconText),

    ButtonSize: typeof(ButtonSize),
}

export type SpinWindowProps = {
    Scale: Fusion.UsedAs<number>,
    Visible: Fusion.UsedAs<boolean>,

    SpinCount: Fusion.UsedAs<number>,
    RatchetActive: Fusion.UsedAs<boolean>,

    Items: Fusion.UsedAs<{Spinner.SpinnerItemProps}>,
}

local SPIN_SPEED = 0.085

local function Degrees(unit: number): number
    return unit * 360
end

local function SpinWindow<U>(scope: Scope<U>, props: SpinWindowProps)
    local scope: Scope<Components> = scope:innerScope {
        Text = Text,
        Stopwatch = Stopwatch,
        Spinner = Spinner,
        InteractionFrame = InteractionFrame,
        Icon = Icon,
        CloseButton = CloseButton,
        EmbossedFrame = EmbossedFrame,
        ButtonSize = ButtonSize,
        IconText = IconText,
    }

    local stopwatch = scope:Stopwatch()

    local spin = scope:Computed(function(use)
        return (use(stopwatch) :: number) * SPIN_SPEED
    end)

    local sectorProgress = scope:Computed(function(use)
        return ((use(spin) :: number) % (1/8.0)) * 8.0
    end)

    local ratchetRotation = scope:Computed(function(use)
        if not use(props.RatchetActive) then
            return 0
        end

        return -math.max(use(sectorProgress) - 0.85, 0) * (1 / (1 - 0.85)) * 30
    end)

    local questionMarkState = scope:Value(Enum.GuiState.NonInteractable)

    local questionMarkScale = scope:Computed(function(use)
        if use(questionMarkState) == Enum.GuiState.Hover then
            return 1.2
        end

        return 1.0
    end)

    local BUTTON_SIZE = UDim2.fromOffset(200, 60)

    local leftButtonState = scope:Value(Enum.GuiState.NonInteractable)
    local middleButtonState = scope:Value(Enum.GuiState.NonInteractable)
    local rightButtonState = scope:Value(Enum.GuiState.NonInteractable)

    local leftButtonSize = scope:ButtonSize(leftButtonState)
    local middleButtonSize = scope:ButtonSize(middleButtonState)
    local rightButtonSize = scope:ButtonSize(rightButtonState)

    local leftButtonSizeSmooth = scope:Spring(leftButtonSize, 35)
    local middleButtonSizeSmooth = scope:Spring(middleButtonSize, 35)
    local rightButtonSizeSmooth = scope:Spring(rightButtonSize, 35)

    return scope:New "Frame" {
        Size = UDim2.fromOffset(700, 700),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),

        BackgroundTransparency = 1,

        [Children] = {
            scope:New "UIScale" {
                Scale = props.Scale,
            },

            scope:Spinner {
                Size = UDim2.fromOffset(350, 350),
                Position = UDim2.fromScale(0.5, 0.5),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Rotation = scope:Computed(function(use)
                    return Degrees((use(stopwatch) :: number) * 0.085)
                end),
                PercentagesVisible = scope:Computed(function(use)
                    return use(questionMarkState) ~= Enum.GuiState.Idle
                end),
                Items = props.Items,
            },

            scope:CloseButton {
                Position = UDim2.fromScale(0.9, 0.25),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Size = UDim2.fromOffset(85, 85),
            },

            scope:Icon {
                Size = UDim2.fromOffset(75, 75),
                Position = UDim2.fromScale(0.5, 0.15),
                AnchorPoint = Vector2.new(0.5, 0.5),
            
                Icon = Icons.DownArrow,
                IconScale = 1.0,
                Rotation = scope:Spring(ratchetRotation, 25)
            },

            scope:InteractionFrame {
                Size = UDim2.fromOffset(75, 75),
                Position = UDim2.fromScale(1.00 - 0.20, 0.20),
                AnchorPoint = Vector2.new(0.5, 0.5),

                BackgroundTransparency = 1,

                GuiStateChanged = function(state: Enum.GuiState)
                    questionMarkState:set(state)
                end,
            
                Children = {
                    scope:New "UIScale" {
                        Scale = scope:Spring(questionMarkScale, 35),
                    },

                    scope:Icon {
                        Size = UDim2.fromScale(1, 1),
                        Position = UDim2.fromScale(0.5, 0.5),
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Icon = Icons.BlueQuestionMark,
                        Rotation = 12,
                    },
                }
            },

            scope:New "Frame" {
                Size = UDim2.fromScale(1, 0.15),
                Position = UDim2.fromScale(0.5, 0.95),
                AnchorPoint = Vector2.new(0.5, 0.5),

                BackgroundTransparency = 1,

                [Children] = {
                    scope:New "UIListLayout" {
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        FillDirection = Enum.FillDirection.Horizontal,
                        HorizontalAlignment = Enum.HorizontalAlignment.Center,
                        VerticalAlignment = Enum.VerticalAlignment.Center,
                        Padding = UDim.new(0, 25),
                    },

                    scope:New "Frame" {
                        Size = BUTTON_SIZE,
                        LayoutOrder = -1,

                        BackgroundTransparency = 1,

                        [Children] = {
                            scope:New "UIScale" {
                                Scale = 1.0
                            },

                            scope:InteractionFrame {
                                Size = UDim2.fromScale(1, 1),
                                AnchorPoint = Vector2.new(0.5, 0.5),
                                Position = UDim2.fromScale(0.5, 0.5),

                                BackgroundTransparency = 1,

                                GuiStateChanged = function(state: Enum.GuiState)
                                    leftButtonState:set(state)
                                end,

                                Children = {
                                    scope:New "UIScale" {
                                        Scale = leftButtonSizeSmooth
                                    },

                                    scope:EmbossedFrame {
                                        Size = UDim2.fromScale(1, 1),
                                        Position = UDim2.fromScale(0.5, 0.5),
                                        AnchorPoint = Vector2.new(0.5, 0.5),

                                        Color = Color3.fromRGB(173, 138, 255),
                                        CornerRadius = UDim.new(0, 18),
                                        StrokeThickness = 3.5,

                                        Children = scope:Text {
                                            Text = "+10 Spins!",
                                            TextSize = 42,
                                            StrokeSize = 2.5,
                                        },
                                    }
                                }
                            }
                        }
                    },

                    scope:New "Frame" {
                        Size = BUTTON_SIZE,
                        LayoutOrder = 0,

                        BackgroundTransparency = 1,

                        [Children] = {
                            scope:New "UIScale" {
                                Scale = 1.2
                            },

                            scope:InteractionFrame {
                                Size = UDim2.fromScale(1, 1),
                                AnchorPoint = Vector2.new(0.5, 0.5),
                                Position = UDim2.fromScale(0.5, 0.5),

                                BackgroundTransparency = 1,

                                GuiStateChanged = function(state: Enum.GuiState)
                                    middleButtonState:set(state)
                                end,

                                Children = {
                                    scope:New "UIScale" {
                                        Scale = middleButtonSizeSmooth,
                                    },

                                    scope:EmbossedFrame {
                                        Size = UDim2.fromScale(1, 1),
                                        Position = UDim2.fromScale(0.5, 0.5),
                                        AnchorPoint = Vector2.new(0.5, 0.5),

                                        Color = Color3.fromRGB(115, 223, 26),
                                        CornerRadius = UDim.new(0, 18),
                                        StrokeThickness = 3.5,

                                        Children = scope:Text {
                                            Text = scope:Computed(function(use)
                                                return `Spin! ({use(props.SpinCount)})`
                                            end),
                                            
                                            TextSize = 42,
                                            StrokeSize = 2.5,
                                        },
                                    }
                                }
                            }
                        }
                    },

                    scope:New "Frame" {
                        Size = BUTTON_SIZE,
                        LayoutOrder = 1,

                        BackgroundTransparency = 1,

                        [Children] = {
                            scope:New "UIScale" {
                                Scale = 1.0
                            },

                            scope:InteractionFrame {
                                Size = UDim2.fromScale(1, 1),
                                AnchorPoint = Vector2.new(0.5, 0.5),
                                Position = UDim2.fromScale(0.5, 0.5),

                                BackgroundTransparency = 1,

                                GuiStateChanged = function(state: Enum.GuiState)
                                    rightButtonState:set(state)
                                end,

                                Children = {
                                    scope:New "UIScale" {
                                        Scale = rightButtonSizeSmooth
                                    },

                                    scope:EmbossedFrame {
                                        Size = UDim2.fromScale(1, 1),
                                        Position = UDim2.fromScale(0.5, 0.5),
                                        AnchorPoint = Vector2.new(0.5, 0.5),

                                        Color = Color3.fromRGB(140, 0, 255),
                                        CornerRadius = UDim.new(0, 18),
                                        StrokeThickness = 3.5,

                                        Children = scope:Text {
                                            Text = "+100 Spins!",
                                            TextSize = 42,
                                            StrokeSize = 2.5,
                                        },
                                    }
                                }
                            }
                        }
                    }
                }
            },
        }
    }
end

return SpinWindow