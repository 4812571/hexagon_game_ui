--!strict
--!native
--!nolint LocalShadow

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)
local Children = Fusion.Children

local Icon = require(Client.Interface.Icon)

type Scope<T> = Fusion.Scope<typeof(Fusion) & T>

type Components = {
    Icon: typeof(Icon)
}

type CosmeticPreviewProps = {
    Size: Fusion.UsedAs<UDim2>?,
    Position: Fusion.UsedAs<UDim2>?,
    AnchorPoint: Fusion.UsedAs<Vector2>?,

    LayoutOrder: Fusion.UsedAs<number>?,

    Icon: Fusion.UsedAs<string>,
    Title: Fusion.UsedAs<string>,
    TextSize: Fusion.UsedAs<number>,
    Color: Fusion.UsedAs<Color3>,

    CornerRadius: Fusion.UsedAs<UDim>,
    Stroke: Fusion.UsedAs<number>,

    Children: Fusion.Child?,
}

local function CosmeticPreview<U>(scope: Scope<U>, props: CosmeticPreviewProps)
    local scope: Scope<Components> = scope:innerScope {
        Icon = Icon,
    }

    return scope:New "Frame" {
        Size = props.Size,
        Position = props.Position,
        AnchorPoint = props.AnchorPoint,

        [Children] = {
            props.Children,

            scope:Icon {
                Size = UDim2.fromScale(0.75, 0.75),
                Position = UDim2.fromScale(0.5, 0.5),
                AnchorPoint = Vector2.new(0.5, 0.5),

                ZIndex = 0,

                Icon = props.Icon,
            },

            scope:New "TextLabel" {
                Size = UDim2.fromScale(1, 0),
                Position = UDim2.fromScale(0.5, 0),
                AnchorPoint = Vector2.new(0.5, 0.5),

                Text = props.Title,
                TextSize = props.TextSize,
                TextColor3 = Color3.new(1, 1, 1),
                Font = Enum.Font.FredokaOne,

                [Children] = scope:New "UIStroke" {
                    Thickness = props.Stroke,
                },
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
        } :: {Fusion.Child?}
    }
end

return CosmeticPreview