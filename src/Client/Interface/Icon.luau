local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages

local Fusion = require(Packages.Fusion)
local Children = Fusion.Children

type Scope<T> = Fusion.Scope<T>
type UsedAs<T> = Fusion.UsedAs<T>

export type IconProps = {
    Name: UsedAs<string>?,

    Size: UsedAs<UDim2>?,
    Position: UsedAs<UDim2>?,
    AnchorPoint: UsedAs<Vector2>?,
    Rotation: UsedAs<number>?,

    LayoutOrder: UsedAs<number>?,
    ZIndex: UsedAs<number>?,

    Icon: UsedAs<string>,
    IconScale: UsedAs<number>?,
}

local function Icon<U>(scope: Scope<typeof(Fusion) & U>, props: IconProps)
    return scope:New "Frame" {
        Size = props.Size,
        Position = props.Position,
        AnchorPoint = props.AnchorPoint,

        LayoutOrder = props.LayoutOrder,
        ZIndex = props.ZIndex,

        BackgroundTransparency = 1,

        [Children] = {
            scope:New "ImageLabel" {
                Size = UDim2.fromScale(1, 1),
                Position = UDim2.fromScale(0.5, 0.5),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Rotation = props.Rotation,

                BackgroundTransparency = 1,

                Image = props.Icon,

                [Children] = scope:New "UIScale" {
                    Scale = props.IconScale
                },
            },

            scope:New "UIAspectRatioConstraint" {
                AspectRatio = 1,
            },
        }
    }
end

return Icon