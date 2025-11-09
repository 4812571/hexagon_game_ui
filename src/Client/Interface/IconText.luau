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
type UsedAs<T> = Fusion.UsedAs<T>

export type IconSide = "Left" | "Right"

export type Components = {
    Icon: typeof(Icon),
    Text: typeof(Text),
}

export type IconTextProps = {
    Size: UsedAs<UDim2>?,
    Position: UsedAs<UDim2>?,
    AnchorPoint: UsedAs<Vector2>?,

    IconSide: UsedAs<IconSide>,

    Icon: UsedAs<string>,
    IconScale: UsedAs<number>?,
    
    Text: UsedAs<string>,
    TextSize: UsedAs<number>,
    TextStrokeThickness: UsedAs<number>,
}

local function IconText<U>(scope: Scope<U>, props: IconTextProps)
    local scope: Scope<Components> = scope:innerScope {
        Icon = Icon,
        Text = Text,
    }

    return scope:New "Frame" {
        Size = props.Size,
        Position = props.Position,
        AnchorPoint = props.AnchorPoint,

        BackgroundTransparency = 1,
        BackgroundColor3 = Color3.fromRGB(50, 50, 50),

        [Children] = {
            scope:New "UIListLayout" {
                SortOrder = Enum.SortOrder.LayoutOrder,
                FillDirection = Enum.FillDirection.Horizontal,
                Padding = UDim.new(0, 12),
            },

            scope:New "Frame" {
                BackgroundTransparency = 1,
                LayoutOrder = 0,

                Size = UDim2.fromScale(1, 1),
                SizeConstraint = Enum.SizeConstraint.RelativeYY,

                [Children] = {
                    scope:Icon {
                        Size = UDim2.fromScale(1, 1),
                        Icon = props.Icon,
                        IconScale = props.IconScale,
                    },
                },
            },

            scope:Text {
                Text = props.Text,
                TextSize = props.TextSize,
                
                TextXAlignment = scope:Computed(function(use)
                    return if use(props.IconSide) == "Left" then Enum.TextXAlignment.Left else Enum.TextXAlignment.Right
                end),

                LayoutOrder = scope:Computed(function(use)
                    return if use(props.IconSide) == "Left" then 1 else -1
                end),

                StrokeSize = props.TextStrokeThickness,

                Children = scope:New "UIFlexItem" {
                    FlexMode = Enum.UIFlexMode.Fill,
                },
            },
        },
    }
end

return IconText
