--!strict
--!native
--!nolint LocalShadow

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)

local Icon = require(Client.Interface.Icon)
local CloseButton = require(Client.Interface.CloseButton)

local Children = Fusion.Children

type Scope<T> = Fusion.Scope<typeof(Fusion) & T>

export type WindowProps = {
    Title: Fusion.UsedAs<string>,
    Icon: Fusion.UsedAs<string>,
    IconScale: Fusion.UsedAs<number>?,

    WindowScale: Fusion.UsedAs<number>?,
    OnClose: () -> ()?,

    Children: Fusion.Child?,
}

local function Window<U>(scope: Scope<U>, props: WindowProps)
    local scope = scope:innerScope {
        Icon = Icon,
        CloseButton = CloseButton,
    }

    return scope:New "Frame" {
        Size = UDim2.fromOffset(550, 350),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),

        BackgroundTransparency = 1,

        [Children] = {
            props.Children,

            scope:New "Frame" {
                Size = UDim2.fromScale(1, 1),
                Position = UDim2.fromScale(0.5, 0.5),
                AnchorPoint = Vector2.new(0.5, 0.5),
                ZIndex = 0,

                [Children] = {
                    scope:New "UIScale" {
                        Scale = props.WindowScale or 1,
                    },

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

                    scope:New "UIListLayout" {
                        FillDirection = Enum.FillDirection.Vertical,
                        VerticalAlignment = Enum.VerticalAlignment.Top,
                        HorizontalAlignment = Enum.HorizontalAlignment.Center,
                        HorizontalFlex = Enum.UIFlexAlignment.Fill,
                        VerticalFlex = Enum.UIFlexAlignment.Fill,
                    },

                    scope:New "Frame" {
                        Name = "Header",
                        BackgroundTransparency = 1,
                        ZIndex = 0,

                        [Children] = {
                            scope:New "UIFlexItem" {
                                FlexMode = Enum.UIFlexMode.Shrink,
                            },

                            scope:CloseButton {
                                Size = UDim2.fromOffset(75, 75),
                                Position = UDim2.fromScale(1, 0),
                                AnchorPoint = Vector2.new(0.5, 0.5),

                                Activated = props.OnClose,
                            },

                            scope:New "Frame" {
                                Name = "Title",
                                BackgroundTransparency = 1,
                                
                                AutomaticSize = Enum.AutomaticSize.XY,
                                AnchorPoint = Vector2.new(0.15, 1),

                                [Children] = scope:New "Frame" {
                                    BackgroundTransparency = 1,
                                    AutomaticSize = Enum.AutomaticSize.XY,
                                    Rotation = -5,

                                    [Children] = {
                                        scope:New "UIListLayout" {
                                            FillDirection = Enum.FillDirection.Horizontal,
                                            HorizontalAlignment = Enum.HorizontalAlignment.Left,
                                            VerticalAlignment = Enum.VerticalAlignment.Center,
                                            Padding = UDim.new(0, 10),
                                        },

                                        scope:Icon {
                                            Icon = props.Icon,
                                            IconScale = props.IconScale,
                                            Size = UDim2.fromOffset(30, 30),
                                        },

                                        scope:New "TextLabel" {
                                            Text = props.Title,
                                            TextSize = 30,
                                            AutomaticSize = Enum.AutomaticSize.XY,
                                            Font = Enum.Font.FredokaOne,
                                            BackgroundTransparency = 1,
                                            TextColor3 = Color3.fromRGB(255, 255, 255),

                                            [Children] = scope:New "UIStroke" {
                                                Thickness = 2,
                                                LineJoinMode = Enum.LineJoinMode.Miter,
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
end

return Window
