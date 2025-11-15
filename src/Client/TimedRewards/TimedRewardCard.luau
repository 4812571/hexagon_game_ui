--!strict
--!native
--!nolint LocalShadow

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)
local Children = Fusion.Children

local Icon = require(Client.Interface.Icon)
local Text = require(Client.Interface.Text)
local ButtonFrame = require(Client.Interface.ButtonFrame)

type Scope<T> = Fusion.Scope<typeof(Fusion) & T>

type Components = {
    Icon: typeof(Icon),
    Text: typeof(Text),
    ButtonFrame: typeof(ButtonFrame),
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
        Text = Text,
        ButtonFrame = ButtonFrame,
    }

    return scope:ButtonFrame {
        Size = props.Size,
        Position = props.Position,
        AnchorPoint = props.AnchorPoint,

        BackgroundTransparency = 1,

        Scaling = {
            Idle = 1.0,
            Hover = 0.95,
            Press = 0.9,
        },

        Children = scope:New "Frame" {
            Size = UDim2.fromScale(1, 1),
            Position = UDim2.fromScale(0.5, 0.5),
            AnchorPoint = Vector2.new(0.5, 0.5),

            [Children] = {
                scope:Text {
                    Size = UDim2.fromScale(0.9, 0.2),
                    Position = UDim2.fromScale(0.5, 0.15),
                    Text = props.TopText,
                    TextSize = 38,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    StrokeSize = 3.5,
                },

                scope:Text {
                    Size = UDim2.fromScale(0.9, 0.2),
                    Position = UDim2.fromScale(0.5, 1),
                    AnchorPoint = Vector2.new(0.5, 0.5),

                    Text = props.BottomText,
                    TextSize = 38,
                    StrokeSize = 3.5,
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
            },
        },
    }
end

return TimedRewardCard