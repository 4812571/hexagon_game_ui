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

type Scope<T> = Fusion.Scope<typeof(Fusion) & T>

type Components = {
    Icon: typeof(Icon),
    Text: typeof(Text),
}

export type ColorBackgroundProps = {
    Type: "Color",
    Color: Fusion.UsedAs<Color3>,
    Icon: Fusion.UsedAs<string>,
}

export type ImageBackgroundProps = {
    Type: "Image",
    Image: Fusion.UsedAs<string>,
}

export type BackgroundProps = ColorBackgroundProps | ImageBackgroundProps

type CosmeticPreviewProps = {
    Size: Fusion.UsedAs<UDim2>?,
    Position: Fusion.UsedAs<UDim2>?,
    AnchorPoint: Fusion.UsedAs<Vector2>?,

    LayoutOrder: Fusion.UsedAs<number>?,

    
    Title: Fusion.UsedAs<string>,
    TextSize: Fusion.UsedAs<number>,
    
    Background: BackgroundProps,

    CornerRadius: Fusion.UsedAs<UDim>,
    Stroke: Fusion.UsedAs<number>,

    Children: Fusion.Child?,
}

local function CosmeticPreview<U>(scope: Scope<U>, props: CosmeticPreviewProps)
    local scope: Scope<Components> = scope:innerScope {
        Icon = Icon,
        Text = Text,
    }

    local mainChildren = {
        scope:Text {
            Size = UDim2.fromScale(1, 0),
            Position = UDim2.fromScale(0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),

            Text = props.Title,
            TextSize = props.TextSize,
            StrokeSize = props.Stroke,
        },

        scope:New "UICorner" {
            CornerRadius = props.CornerRadius,
        },

        scope:New "UIStroke" {
            Thickness = props.Stroke,
        },
    }

    if props.Background.Type == "Color" then
        return scope:New "Frame" {
            Size = props.Size,
            Position = props.Position,
            AnchorPoint = props.AnchorPoint,
            BackgroundColor3 = props.Background.Color,

            LayoutOrder = props.LayoutOrder,

            [Children] = {
                scope:Icon {
                    Size = UDim2.fromScale(0.75, 0.75),
                    Position = UDim2.fromScale(0.5, 0.5),
                    AnchorPoint = Vector2.new(0.5, 0.5),

                    ZIndex = 0,

                    Icon = props.Background.Icon,
                },

                mainChildren,
                props.Children,
            } :: {Fusion.Child?}
        }
    end

    if props.Background.Type == "Image" then
        return scope:New "ImageLabel" {
            Size = props.Size,
            Position = props.Position,
            AnchorPoint = props.AnchorPoint,
            Image = props.Background.Image,

            LayoutOrder = props.LayoutOrder,

            [Children] = {
                mainChildren,
                props.Children,
            } :: {Fusion.Child?}
        }
    end

    error("Unrecognized background type")
end

return CosmeticPreview