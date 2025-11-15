--!strict
--!native
--!nolint LocalShadow

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)
local peek = Fusion.peek
local Out = Fusion.Out
local Children = Fusion.Children

local Icon = require(Client.Interface.Icon)
local Text = require(Client.Interface.Text)
local EmbossedFrame = require(Client.Interface.EmbossedFrame)
local ButtonFrame = require(Client.Interface.ButtonFrame)

type Scope<T> = Fusion.Scope<typeof(Fusion) & T>

type Components = {
    Icon: typeof(Icon),
    Text: typeof(Text),
    EmbossedFrame: typeof(EmbossedFrame),
    ButtonFrame: typeof(ButtonFrame),
}

type TopbarItemProps = {
    Size: Fusion.UsedAs<UDim2>?,
    Position: Fusion.UsedAs<UDim2>?,
    AnchorPoint: Fusion.UsedAs<Vector2>?,

    LayoutOrder: Fusion.UsedAs<number>?,

    Icon: Fusion.UsedAs<string>,
    IconScale: Fusion.UsedAs<number>?,
    BounceScale: Fusion.UsedAs<number>,
    Text: Fusion.UsedAs<string>,

    IconPositionOut: Fusion.Value<Vector2>,

    OnPurchaseButton: () -> (),
}

local function TopbarItem<U>(scope: Scope<U>, props: TopbarItemProps)
    local scope: Scope<Components> = scope:innerScope {
        Icon = Icon,
        Text = Text,
        EmbossedFrame = EmbossedFrame,
        ButtonFrame = ButtonFrame,
    }

    local iconPosition = scope:Value(Vector2.zero)
    local iconSize = scope:Value(Vector2.zero)

    local position = scope:Computed(function(use)
        return use(iconPosition) + use(iconSize) / 2
    end)

    scope:Observer(position):onBind(function()
        props.IconPositionOut:set(peek(position))
    end)

    return scope:New "Frame" {
        Size = props.Size,
        Position = props.Position,
        AnchorPoint = props.AnchorPoint,

        BackgroundTransparency = 1,
        LayoutOrder = props.LayoutOrder,

        [Children] = scope:New "Frame" {
            Size = UDim2.fromScale(1, 1),

            [Children] = {
                scope:New "UIScale" {
                    Scale = props.BounceScale,
                },

                scope:New "UICorner" {
                    CornerRadius = UDim.new(1, 0),
                },

                scope:New "UIStroke" {
                    Thickness = 4,
                    Color = Color3.fromRGB(0, 0, 0),
                },

                scope:New "Frame" {
                    Size = UDim2.fromScale(1.2, 1.2),
                    Position = UDim2.fromScale(0, 0.5),
                    AnchorPoint = Vector2.new(0.25, 0.5),
                    BackgroundTransparency = 1,
                    SizeConstraint = Enum.SizeConstraint.RelativeYY,
                
                    [Out "AbsolutePosition"] = iconPosition,
                    [Out "AbsoluteSize"] = iconSize,
                
                    [Children] = scope:Icon {
                        Size = UDim2.fromScale(1.2, 1.2),
                        Position = UDim2.fromScale(0.5, 0.5),
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Icon = props.Icon,
                        IconScale = props.IconScale,
                    }
                },

                scope:Text {
                    BackgroundTransparency = 1,
                    Text = props.Text,
                    TextSize = 48,
                    StrokeSize = 2,
                },

                scope:ButtonFrame {
                    Size = UDim2.fromScale(0.65, 0.65),
                    SizeConstraint = Enum.SizeConstraint.RelativeYY,
                    Position = UDim2.fromScale(1, 0.5),
                    AnchorPoint = Vector2.new(0.5, 0.5),

                    BackgroundTransparency = 1,

                    Scaling = {
                        Idle = 1.0,
                        Hover = 1.10,
                        Press = 0.90,
                    },

                    Activated = props.OnPurchaseButton,

                    Children = scope:New "Frame" {
                        Size = UDim2.fromScale(1, 1),
                        Position = UDim2.fromScale(0.5, 0.5),
                        AnchorPoint = Vector2.new(0.5, 0.5),

                        BackgroundColor3 = Color3.fromRGB(53, 255, 3),

                        [Children] = {
                            scope:New "UICorner" {
                                CornerRadius = UDim.new(1, 0),
                            },

                            scope:New "UIStroke" {
                                Thickness = 4,
                                Color = Color3.fromRGB(0, 0, 0),
                            },

                            scope:Text {
                                Size = UDim2.fromScale(0.8, 0.8),
                                Text = "+",
                                TextSize = 68,
                                StrokeSize = 2.0,
                            },
                        },
                    },
                },
            },
        },
    }
end

return TopbarItem