--!strict
--!native
--!nolint LocalShadow

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)
local peek = Fusion.peek
local Out = Fusion.Out
local Children = Fusion.Children

local Icon = require(Client.Interface.Icon)
local EmbossedFrame = require(Client.Interface.EmbossedFrame)
local InteractionFrame = require(Client.Interface.InteractionFrame)

type Scope<T> = Fusion.Scope<typeof(Fusion) & T>

type TopbarItemProps = {
    Size: Fusion.UsedAs<UDim2>?,
    Position: Fusion.UsedAs<UDim2>?,
    AnchorPoint: Fusion.UsedAs<Vector2>?,

    LayoutOrder: Fusion.UsedAs<number>?,

    Icon: Fusion.UsedAs<string>,
    IconScale: Fusion.UsedAs<number>?,
    BounceScale: Fusion.UsedAs<number>,
    Text: Fusion.UsedAs<string>,

    IconPositionOut: Fusion.Value<Vector2>,

    OnPurchaseButton: () -> (),
}

local function TopbarItem<U>(scope: Scope<U>, props: TopbarItemProps)
    local scope = scope:innerScope {
        Icon = Icon,
        EmbossedFrame = EmbossedFrame,
        InteractionFrame = InteractionFrame,
    }

    local purchaseButtonState = scope:Value(Enum.GuiState.NonInteractable)

    local purchaseButtonScale = scope:Computed(function(use)
        if use(purchaseButtonState) == Enum.GuiState.Press then
            return 0.90
        end

        if use(purchaseButtonState) == Enum.GuiState.Hover then
            return 1.10
        end

        return 1.0
    end)

    local iconPosition = scope:Value(Vector2.zero)
    local iconSize = scope:Value(Vector2.zero)

    local position = scope:Computed(function(use)
        return use(iconPosition) + use(iconSize) / 2
    end)

    scope:Observer(position):onBind(function()
        props.IconPositionOut:set(peek(position))
    end)

    return scope:New "Frame" {
        Size = props.Size,
        Position = props.Position,
        AnchorPoint = props.AnchorPoint,

        BackgroundTransparency = 1,
        LayoutOrder = props.LayoutOrder,

        [Children] = scope:New "Frame" {
            Size = UDim2.fromScale(1, 1),

            [Children] = {
                scope:New "UIScale" {
                    Scale = props.BounceScale,
                },

                scope:New "UICorner" {
                    CornerRadius = UDim.new(1, 0),
                },

                scope:New "UIStroke" {
                    Thickness = 4,
                    Color = Color3.fromRGB(0, 0, 0),
                },

                scope:New "Frame" {
                    Size = UDim2.fromScale(1.2, 1.2),
                    Position = UDim2.fromScale(0, 0.5),
                    AnchorPoint = Vector2.new(0.25, 0.5),
                    BackgroundTransparency = 1,
                    SizeConstraint = Enum.SizeConstraint.RelativeYY,
                
                    [Out "AbsolutePosition"] = iconPosition,
                    [Out "AbsoluteSize"] = iconSize,
                
                    [Children] = scope:Icon {
                        Size = UDim2.fromScale(1.2, 1.2),
                        Position = UDim2.fromScale(0.5, 0.5),
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Icon = props.Icon,
                        IconScale = props.IconScale,
                    }
                },

                scope:New "TextLabel" {
                    Size = UDim2.fromScale(1, 1),
                    Position = UDim2.fromScale(0.5, 0.5),
                    AnchorPoint = Vector2.new(0.5, 0.5),

                    BackgroundTransparency = 1,

                    Text = props.Text,
                    TextColor3 = Color3.new(1, 1, 1),
                    Font = Enum.Font.FredokaOne,

                    TextSize = 48,
                    TextXAlignment = Enum.TextXAlignment.Center,
                    TextYAlignment = Enum.TextYAlignment.Center,

                    [Children] = scope:New "UIStroke" {
                        Thickness = 2,
                        Color = Color3.fromRGB(0, 0, 0),
                    }
                },

                scope:InteractionFrame {
                    Size = UDim2.fromScale(0.65, 0.65),
                    SizeConstraint = Enum.SizeConstraint.RelativeYY,
                    Position = UDim2.fromScale(1, 0.5),
                    AnchorPoint = Vector2.new(0.5, 0.5),

                    BackgroundTransparency = 1,

                    Activated = props.OnPurchaseButton,

                    GuiStateChanged = function(newState: Enum.GuiState)
                        purchaseButtonState:set(newState)
                    end,

                    Children = scope:New "Frame" {
                        Size = UDim2.fromScale(1, 1),
                        Position = UDim2.fromScale(0.5, 0.5),
                        AnchorPoint = Vector2.new(0.5, 0.5),

                        BackgroundColor3 = Color3.fromRGB(53, 255, 3),

                        [Children] = {
                            scope:New "UICorner" {
                                CornerRadius = UDim.new(1, 0),
                            },

                            scope:New "UIStroke" {
                                Thickness = 4,
                                Color = Color3.fromRGB(0, 0, 0),
                            },

                            scope:New "UIScale" {
                                Scale = scope:Spring(purchaseButtonScale, 25),
                            },

                            scope:New "TextLabel" {
                                Size = UDim2.fromScale(0.8, 0.8),
                                Position = UDim2.fromScale(0.5, 0.5),
                                AnchorPoint = Vector2.new(0.5, 0.5),
                                BackgroundTransparency = 1,
                                Text = "+",
                                TextColor3 = Color3.new(1, 1, 1),
                                Font = Enum.Font.FredokaOne,
                                
                                TextXAlignment = Enum.TextXAlignment.Center,
                                TextYAlignment = Enum.TextYAlignment.Center,
                                TextSize = 68,

                                [Children] = scope:New "UIStroke" {
                                    Thickness = 2,
                                    Color = Color3.fromRGB(0, 0, 0),
                                }
                            },
                        },
                    },
                },
            },
        },
    }
end

return TopbarItem