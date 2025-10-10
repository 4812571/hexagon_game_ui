local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)

local Frame = require(Client.Interface.Frame)
local TextLabel = require(Client.Interface.TextLabel)
local ListLayout = require(Client.Interface.ListLayout)
local FlexItem = require(Client.Interface.FlexItem)
local Icon = require(Client.Interface.Icon)
local CloseButton = require(Client.Interface.CloseButton)

export type WindowProps = {
    Scope: Fusion.Scope<typeof(Fusion)>,

    Name: Fusion.UsedAs<string>?,

    LayoutOrder: Fusion.UsedAs<number>?,

    AnchorPoint: Fusion.UsedAs<Vector2>?,
    Position: Fusion.UsedAs<UDim2>?,
    Size: Fusion.UsedAs<UDim2>?,

    Title: Fusion.UsedAs<string>,
    Icon: Fusion.UsedAs<string>,
    IconScale: Fusion.UsedAs<number>?,

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

                Name = "Header",

                BackgroundTransparency = 1,

                Children = {
                    FlexItem {
                        Scope = scope,

                        FlexMode = Enum.UIFlexMode.Shrink,
                    },

                    CloseButton {
                        Scope = scope,

                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Position = UDim2.fromScale(1, 0),
                        Size = UDim2.fromOffset(75, 75),

                        Activated = props.Close,
                    },

                    Frame {
                        Scope = scope,

                        Name = "Title",

                        BackgroundTransparency = 1,

                        AutomaticSize = Enum.AutomaticSize.XY,

                        AnchorPoint = Vector2.new(0.15, 1),

                        Children = Frame {
                            Scope = scope,

                            BackgroundTransparency = 1,

                            AutomaticSize = Enum.AutomaticSize.XY,

                            Rotation = -5,

                            Children = {
                                ListLayout {
                                    Scope = scope,

                                    FillDirection = Enum.FillDirection.Horizontal,

                                    HorizontalAlignment = Enum.HorizontalAlignment.Left,
                                    VerticalAlignment = Enum.VerticalAlignment.Top,

                                    Padding = UDim.new(0, 10),
                                },

                                Icon {
                                    Scope = scope,

                                    Icon = props.Icon,
                                    IconScale = props.IconScale,
                                },

                                TextLabel {
                                    Scope = scope,

                                    Text = props.Title,

                                    TextSize = 30,

                                    AutomaticSize = Enum.AutomaticSize.XY,
                                },
                            }
                        }
                    }
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