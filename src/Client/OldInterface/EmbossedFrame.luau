local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)

local Frame = require(Client.Interface.Frame)
local ListLayout = require(Client.Interface.ListLayout)

export type EmbossedFrameProps = {
    Scope: Fusion.Scope<typeof(Fusion)>,

    Name: Fusion.UsedAs<string>?,

    LayoutOrder: Fusion.UsedAs<number>?,

    BackgroundColor3: Fusion.UsedAs<Color3>?,
    BackgroundTransparency: Fusion.UsedAs<number>?,
    BackgroundGradient: Fusion.UsedAs<ColorSequence>?,

    AnchorPoint: Fusion.UsedAs<Vector2>?,
    Position: Fusion.UsedAs<UDim2>?,
    Size: Fusion.UsedAs<UDim2>?,

    SizeConstraint: Fusion.UsedAs<Enum.SizeConstraint>?,

    AutomaticSize: Fusion.UsedAs<Enum.AutomaticSize>?,

    CornerRadius: Fusion.UsedAs<UDim>?,

    PaddingBottom: Fusion.UsedAs<UDim>?,
    PaddingTop: Fusion.UsedAs<UDim>?,
    PaddingRight: Fusion.UsedAs<UDim>?,
    PaddingLeft: Fusion.UsedAs<UDim>?,

    StrokeThickness: Fusion.UsedAs<number>?,
    StrokeColor: Fusion.UsedAs<Color3>?,
    StrokeTransparency: Fusion.UsedAs<number>?,

    Children: Fusion.UsedAs<Fusion.Child>?,
}

local function EmbossedFrame(props: EmbossedFrameProps)
    local scope = props.Scope

    local backgroundColor = props.BackgroundColor3 or Color3.fromRGB(255, 255, 255)

    return Frame {
        Scope = scope,

        BackgroundColor3 = if props.BackgroundGradient then backgroundColor else scope:Computed(function(use)
            local color: Color3 = use(backgroundColor)
            local h, s, v = color:ToHSV()

            return Color3.fromHSV(h, s, v * 0.65)
        end),
        BackgroundTransparency = props.BackgroundTransparency or 0,

        AnchorPoint = props.AnchorPoint,
        Position = props.Position,
        Size = props.Size,

        AutomaticSize = props.AutomaticSize,

        Children = {
            ListLayout {
                Scope = scope,

                FillDirection = Enum.FillDirection.Vertical,

                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                VerticalAlignment = Enum.VerticalAlignment.Center,

                HorizontalFlex = Enum.UIFlexAlignment.Fill,
                VerticalFlex = Enum.UIFlexAlignment.Fill,
            },

            scope:New "UIStroke" {
                Thickness = props.StrokeThickness or 4,
                Color = props.StrokeColor or Color3.fromRGB(0, 0, 0),
                Transparency = props.StrokeTransparency or 0,
            },

            scope:New "UICorner" {
                CornerRadius = props.CornerRadius or UDim.new(0, 10),
            },

            scope:New "UIPadding" {
                PaddingBottom = props.PaddingBottom or UDim.new(0, 10),
                PaddingTop = props.PaddingTop,
                PaddingLeft = props.PaddingLeft,
                PaddingRight = props.PaddingRight,
            },

            Frame {
                Scope = scope,

                AutomaticSize = props.AutomaticSize,

                BackgroundColor3 = if props.BackgroundGradient then Color3.fromRGB(255, 255, 255) else backgroundColor,
                BackgroundTransparency = props.BackgroundTransparency or 0,

                Children = {
                    scope:New "UICorner" {
                        CornerRadius = props.CornerRadius or UDim.new(0, 10),
                    },

                    scope:New "UIGradient" {
                        Name = "UIGradient",
                        Color = props.BackgroundGradient or ColorSequence.new({
                            ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                            ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 200)),
                        }),
                        Rotation = 90,
                    },

                    Children = props.Children,
                }
            },
        }
    }
end

return EmbossedFrame