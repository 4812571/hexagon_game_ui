local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)

local Frame = require(Client.Interface.Frame)
local TextButton = require(Client.Interface.TextButton)
local ListLayout = require(Client.Interface.ListLayout)
local FlexItem = require(Client.Interface.FlexItem)

export type WindowProps = {
    Scope: Fusion.Scope<typeof(Fusion)>,

    Name: Fusion.UsedAs<string>?,

    LayoutOrder: Fusion.UsedAs<number>?,

    AnchorPoint: Fusion.UsedAs<Vector2>?,
    Position: Fusion.UsedAs<UDim2>?,
    Size: Fusion.UsedAs<UDim2>?,

    Children: Fusion.UsedAs<Fusion.Child>?,

    Close: () -> ()?,
}

local function Window(props: WindowProps)
    local scope = props.Scope

    return Frame {
        Scope = scope,

        Name = props.Name or "Window",

        LayoutOrder = props.LayoutOrder,

        AnchorPoint = props.AnchorPoint or Vector2.new(0.5, 0.5),
        Position = props.Position or UDim2.fromScale(0.5, 0.5),
        Size = props.Size or UDim2.fromOffset(465, 350),

        Children = {
            scope:New "UIStroke" {
                Thickness = 4,
            },

            scope:New "UICorner" {
                CornerRadius = UDim.new(0, 40),
            },

            scope:New "UIPadding" {
                PaddingLeft = UDim.new(0, 15),
                PaddingRight = UDim.new(0, 15),
                PaddingTop = UDim.new(0, 15),
                PaddingBottom = UDim.new(0, 15),
            },

            ListLayout {
                Scope = scope,

                FillDirection = Enum.FillDirection.Vertical,

                VerticalAlignment = Enum.VerticalAlignment.Top,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,

                HorizontalFlex = Enum.UIFlexAlignment.Fill,
                VerticalFlex = Enum.UIFlexAlignment.Fill,
            },

            Frame {
                Scope = scope,

                Name = "CloseButton",

                BackgroundTransparency = 1,

                Children = {
                    FlexItem {
                        Scope = scope,

                        FlexMode = Enum.UIFlexMode.Shrink,
                    },

                    TextButton {
                        Scope = scope,

                        Name = "CloseButton",

                        BackgroundColor3 = Color3.fromRGB(255, 63, 63),

                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Position = UDim2.fromScale(1, 0),
                        Size = UDim2.fromOffset(75, 75),

                        Text = "X",

                        Activated = props.Close,
                    },
                }
            },

            Frame {
                Scope = scope,

                Name = "WindowContent",

                BackgroundTransparency = 1,

                Children = props.Children,
            }
        }
    }
end

return Window