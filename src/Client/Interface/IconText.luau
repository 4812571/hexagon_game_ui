--!strict
--!nolint LocalShadow

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)
local Children = Fusion.Children

local Icon = require(Client.Interface.Icon)

type Scope<T> = Fusion.Scope<typeof(Fusion) & T>
type UsedAs<T> = Fusion.UsedAs<T>

export type IconSide = "Left" | "Right"

export type IconTextProps = {
    Size: UsedAs<UDim2>?,
    Position: UsedAs<UDim2>?,
    AnchorPoint: UsedAs<Vector2>?,

    IconSide: UsedAs<IconSide>,

    Icon: UsedAs<string>,
    
    Text: UsedAs<string>,
    TextSize: UsedAs<number>,
    TextStrokeThickness: UsedAs<number>,
}

local function IconText<U>(scope: Scope<U>, props: IconTextProps)
    local scope = scope:innerScope {
        Icon = Icon,
    }

    return scope:New "Frame" {
        Size = props.Size,
        Position = props.Position,
        AnchorPoint = props.AnchorPoint,

        BackgroundTransparency = 1,

        [Children] = {
            scope:New "UIListLayout" {
                SortOrder = Enum.SortOrder.LayoutOrder,
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalFlex = Enum.UIFlexAlignment.Fill,
                VerticalFlex = Enum.UIFlexAlignment.Fill,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                HorizontalAlignment = Enum.HorizontalAlignment.Left,
                Padding = UDim.new(0, 12),
            },

            scope:New "Frame" {
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                LayoutOrder = 0,

                [Children] = {
                    scope:Icon {
                        Size = UDim2.fromScale(1, 1),
                        Icon = props.Icon,
                    },

                    scope:New "UIAspectRatioConstraint" {
                        AspectRatio = 1,
                    },
                }
            },

            scope:New "TextLabel" {
                BackgroundTransparency = 1,
                
                Text = props.Text,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 92,
                TextXAlignment = scope:Computed(function(use)
                    return if use(props.IconSide) == "Left" then Enum.TextXAlignment.Left else Enum.TextXAlignment.Right
                end),
                TextYAlignment = Enum.TextYAlignment.Center,
                Font = Enum.Font.FredokaOne,

                LayoutOrder = scope:Computed(function(use)
                    return if use(props.IconSide) == "Left" then 1 else -1
                end),

                [Children] = {
                    scope:New "UIStroke" {
                        Color = Color3.fromRGB(0, 0, 0),
                        Thickness = 4,
                    },

                    scope:New "UIFlexItem" {
                        FlexMode = Enum.UIFlexMode.Fill,
                    }
                }
            }
        }
    }
end

return IconText