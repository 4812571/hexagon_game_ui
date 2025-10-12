--!strict
--!native

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage.Packages

local Fusion = require(Packages.Fusion)
local Children = Fusion.Children

type Scope<T> = Fusion.Scope<T>
type UsedAs<T> = Fusion.UsedAs<T>

export type EmbossedFrameProps = {
    Name: UsedAs<string>?,

    Size: UsedAs<UDim2>?,
    Position: UsedAs<UDim2>?,
    AnchorPoint: UsedAs<Vector2>?,

    SizeConstraint: UsedAs<Enum.SizeConstraint>?,
    ClipsDescendants: UsedAs<boolean>?,

    Color: UsedAs<Color3>,
    CornerRadius: UsedAs<UDim>?,
    
    StrokeColor: UsedAs<Color3>?,
    StrokeThickness: UsedAs<number>?,

    Children: Fusion.Child?,
}

local EMBOSS_PADDING = UDim.new(0.05, 0)

local WHITE = Color3.new(1, 1, 1)
local BLACK = Color3.new(0, 0, 0)

local DARKEN_FACTOR = 0.45

local function EmbossedFrame<U>(scope: Scope<typeof(Fusion) & U>, props: EmbossedFrameProps)
    return scope:New "Frame" {
        Name = props.Name,

        Size = props.Size,
        Position = props.Position,
        AnchorPoint = props.AnchorPoint,

        SizeConstraint = props.SizeConstraint,
        ClipsDescendants = props.ClipsDescendants,

        BackgroundTransparency = 0,

        BackgroundColor3 = scope:Computed(function(use)
            return use(props.Color):Lerp(BLACK, DARKEN_FACTOR)
        end),

        [Children] = {
            props.Children,

            scope:New "UIStroke" {
                Thickness = props.StrokeThickness,
                Color = props.StrokeColor,
                Transparency = 0,
            },

            scope:New "UICorner" {
                CornerRadius = props.CornerRadius,
            },

            scope:New "UIPadding" {
                PaddingBottom = EMBOSS_PADDING,
            },

            scope:New "Frame" {
                Name = "EmbossedInner",

                Size = UDim2.fromScale(1, 1),
                BackgroundColor3 = Color3.new(1, 1, 1),
                ZIndex = 0,

                [Children] = {
                    scope:New "UICorner" {
                        CornerRadius = props.CornerRadius,
                    },

                    scope:New "UIGradient" {
                        Color = scope:Computed(function(use)
                            return ColorSequence.new {
                                ColorSequenceKeypoint.new(0, use(props.Color):Lerp(WHITE, 0.55)),
                                ColorSequenceKeypoint.new(0.05, use(props.Color)),
                                ColorSequenceKeypoint.new(1, use(props.Color)),
                            }
                        end),

                        Rotation = 90,
                    }
                }
            },
        }
    }
end

return EmbossedFrame
