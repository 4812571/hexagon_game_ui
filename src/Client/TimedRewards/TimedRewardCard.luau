--!strict
--!native
--!nolint LocalShadow

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)
local Children = Fusion.Children

local Icon = require(Client.Interface.Icon)
local InteractionFrame = require(Client.Interface.InteractionFrame)

type Scope<T> = Fusion.Scope<typeof(Fusion) & T>

type Components = {
    Icon: typeof(Icon),
    InteractionFrame: typeof(InteractionFrame),
}

type TimedRewardCardProps = {
    Size: Fusion.UsedAs<UDim2>?,
    Position: Fusion.UsedAs<UDim2>?,
    AnchorPoint: Fusion.UsedAs<Vector2>?,

    Color: Fusion.UsedAs<Color3>,
    Icon: Fusion.UsedAs<string>,
    TopText: Fusion.UsedAs<string>,
    BottomText: Fusion.UsedAs<string>,

    CornerRadius: Fusion.UsedAs<UDim>,
    Stroke: Fusion.UsedAs<number>,
}

local function TimedRewardCard<U>(scope: Scope<U>, props: TimedRewardCardProps)
    local scope: Scope<Components> = scope:innerScope {
        Icon = Icon,
        InteractionFrame = InteractionFrame,
    }

    local guiState = scope:Value(Enum.GuiState.NonInteractable)

    local scale = scope:Computed(function(use)
        if use(guiState) == Enum.GuiState.Hover then
            return 0.95
        end

        if use(guiState) == Enum.GuiState.Press then
            return 0.9
        end

        return 1.0
    end)

    return scope:InteractionFrame {
        Size = props.Size,
        Position = props.Position,
        AnchorPoint = props.AnchorPoint,

        BackgroundTransparency = 1,

        GuiStateChanged = function(state: Enum.GuiState)
            guiState:set(state)
        end,

        Children = {
            scope:New "UIScale" {
                Scale = scope:Spring(scale, 35),
            },

            scope:New "Frame" {
                Size = UDim2.fromScale(1, 1),
                Position = UDim2.fromScale(0.5, 0.5),
                AnchorPoint = Vector2.new(0.5, 0.5),

                [Children] = {
                    scope:New "TextLabel" {
                        Size = UDim2.fromScale(0.9, 0.2),
                        Position = UDim2.fromScale(0.5, 0.15),
                        AnchorPoint = Vector2.new(0.5, 0.5),

                        BackgroundTransparency = 1,

                        Text = props.TopText,
                        TextColor3 = Color3.new(1, 1, 1),
                        TextSize = 38,
                        Font = Enum.Font.FredokaOne,
                        TextXAlignment = Enum.TextXAlignment.Right,

                        [Children] = scope:New "UIStroke" {
                            Thickness = props.Stroke,
                        },
                    },

                    scope:New "TextLabel" {
                        Size = UDim2.fromScale(0.9, 0.2),
                        Position = UDim2.fromScale(0.5, 1),
                        AnchorPoint = Vector2.new(0.5, 0.5),

                        BackgroundTransparency = 1,

                        Text = props.BottomText,
                        TextColor3 = Color3.new(1, 1, 1),
                        TextSize = 38,
                        Font = Enum.Font.FredokaOne,

                        [Children] = scope:New "UIStroke" {
                            Thickness = props.Stroke,
                        },
                    },

                    scope:Icon {
                        Size = UDim2.fromScale(0.75, 0.75),
                        Position = UDim2.fromScale(0.5, 0.5),
                        AnchorPoint = Vector2.new(0.5, 0.5),

                        ZIndex = 0,

                        Icon = props.Icon,
                    },

                    scope:New "UIGradient" {
                        Color = scope:Computed(function(use)
                            return ColorSequence.new(use(props.Color), use(props.Color):Lerp(Color3.new(1, 1, 1), 0.5))
                        end),
                        Rotation = -90,
                    },

                    scope:New "UICorner" {
                        CornerRadius = props.CornerRadius,
                    },

                    scope:New "UIStroke" {
                        Thickness = props.Stroke,
                    },
                }
            },
        }
    }
end

return TimedRewardCard