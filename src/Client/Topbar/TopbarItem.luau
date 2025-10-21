--!strict
--!native
--!nolint LocalShadow

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)
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

    OnPurchaseButton: () -> (),
}

local function TopbarItem<U>(scope: Scope<U>, props: TopbarItemProps)
    local scope = scope:innerScope {
        Icon = Icon,
        EmbossedFrame = EmbossedFrame,
        InteractionFrame = InteractionFrame,
    }

    local absoluteSize = scope:Value(Vector2.new(0, 0))

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

    return scope:New "Frame" {
        Size = props.Size,
        Position = props.Position,
        AnchorPoint = props.AnchorPoint,

        BackgroundTransparency = 1,
        LayoutOrder = props.LayoutOrder,

        [Out "AbsoluteSize"] = absoluteSize,

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

                scope:Icon {
                    Size = UDim2.fromScale(1.2, 1.2),
                    Position = scope:Computed(function(use)
                        return UDim2.fromOffset(use(absoluteSize).Y / 2, use(absoluteSize).Y / 2)
                    end),
                    AnchorPoint = Vector2.new(0.5, 0.5),

                    Icon = props.Icon,
                  
                    IconScale = props.IconScale,
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
                    Size = scope:Computed(function(use)
                        return UDim2.fromOffset(use(absoluteSize).Y * 0.65, use(absoluteSize).Y * 0.65)
                    end),
                    Position = scope:Computed(function(use)
                        return UDim2.fromOffset(use(absoluteSize).X - use(absoluteSize).Y * 0.125, use(absoluteSize).Y / 2)
                    end),
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
                        }
                    }
                },
            }
        }
    }
end

return TopbarItem