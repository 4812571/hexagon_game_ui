--!strict
--!native
--!nolint LocalShadow

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)
local Children = Fusion.Children

local Icons = require(Common.Icons)

local Window = require(Client.Interface.Window)
local InteractionFrame = require(Client.Interface.InteractionFrame)
local EmbossedFrame = require(Client.Interface.EmbossedFrame)
local IconText = require(Client.Interface.IconText)

local CosmeticPreview = require(Client.Cosmetics.CosmeticPreview)
local CosmeticShopCard = require(Client.Cosmetics.CosmeticShopCard)

type Scope<T> = Fusion.Scope<typeof(Fusion) & T>

export type Components = {
    Window: typeof(Window),
    InteractionFrame: typeof(InteractionFrame),
    EmbossedFrame: typeof(EmbossedFrame),
    IconText: typeof(IconText),

    CosmeticPreview: typeof(CosmeticPreview),
    CosmeticShopCard: typeof(CosmeticShopCard),
}

export type SkinsWindowProps = {

}

local function Range(count: number): {number}
    local result = {}

    for i = 1, count do
        table.insert(result, i)
    end

    return result
end

local function PaddedSize(count: number, size: number, padding: number): number
    return (size + padding) * count - padding
end

local function ButtonScale(state: Enum.GuiState): number
    if state == Enum.GuiState.Hover then
        return 1.05
    end

    if state == Enum.GuiState.Press then
        return 0.95
    end

    return 1.0
end

local function SkinsWindow<U>(scope: Scope<U>, props: SkinsWindowProps)
    local scope: Scope<Components> = scope:innerScope {
        Window = Window,
        InteractionFrame = InteractionFrame,
        EmbossedFrame = EmbossedFrame,
        IconText = IconText,

        CosmeticPreview = CosmeticPreview,
        CosmeticShopCard = CosmeticShopCard,
    }

    local ITEM_SIZE = 125
    local ITEM_PADDING = 10

    local ITEMS_PER_ROW = 3

    local itemsFrameWidth = scope:Computed(function(use)
        return PaddedSize(use(ITEMS_PER_ROW), use(ITEM_SIZE), use(ITEM_PADDING))
    end)

    local equipButtonState = scope:Value(Enum.GuiState.NonInteractable)
    local variousButtonState = scope:Value(Enum.GuiState.NonInteractable)
    local flagsButtonState = scope:Value(Enum.GuiState.NonInteractable)

    local equipButtonSize = scope:Computed(function(use)
        return ButtonScale(use(equipButtonState))
    end)

    local variousButtonSize = scope:Computed(function(use)
        return ButtonScale(use(variousButtonState))
    end)

    local flagsButtonSize = scope:Computed(function(use)
        return ButtonScale(use(flagsButtonState))
    end)

    return scope:Window {
        Title = "Skins",
        Icon = Icons.Aura,
        IconScale = 1.45,

        Children = scope:New "Frame" {
            Size = UDim2.fromScale(0.9, 0.9),
            Position = UDim2.fromScale(0.5, 0.5),
            AnchorPoint = Vector2.new(0.5, 0.5),

            BackgroundTransparency = 1,

            [Children] = {
                scope:New "UIListLayout" {
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    FillDirection = Enum.FillDirection.Vertical,
                    VerticalFlex = Enum.UIFlexAlignment.Fill,
                },

                scope:New "Frame" {
                    LayoutOrder = 1,
                    BackgroundTransparency = 1,

                    Size = UDim2.fromScale(1, 0.125),

                    [Children] = {
                        scope:New "UIFlexItem" {
                            FlexMode = Enum.UIFlexMode.None,
                        },

                        scope:New "UIListLayout" {
                            SortOrder = Enum.SortOrder.LayoutOrder,
                            FillDirection = Enum.FillDirection.Horizontal,

                            VerticalAlignment = Enum.VerticalAlignment.Center,
                            HorizontalAlignment = Enum.HorizontalAlignment.Center,

                            Padding = UDim.new(0, 20)
                        },

                        scope:InteractionFrame {
                            LayoutOrder = 1,
                            BackgroundTransparency = 1,
                            
                            Size = UDim2.fromOffset(245, 55),
                        
                            GuiStateChanged = function(state: Enum.GuiState)
                                variousButtonState:set(state)
                            end,

                            Children = scope:EmbossedFrame {
                                Size = UDim2.fromScale(1, 1),
                                Position = UDim2.fromScale(0.5, 0.5),
                                AnchorPoint = Vector2.new(0.5, 0.5),

                                Color = Color3.fromRGB(150, 134, 252),
                                
                                StrokeThickness = 2.5,
                                CornerRadius = UDim.new(0.25, 0),

                                Children = {
                                    scope:New "UIScale" {
                                        Scale = scope:Spring(variousButtonSize, 35),
                                    },

                                    scope:IconText {
                                        Size = UDim2.fromScale(0.65, 0.80),
                                        Position = UDim2.fromScale(0.5, 0.5),
                                        AnchorPoint = Vector2.new(0.5, 0.5),

                                        Icon = Icons.Pencil,
                                        IconSide = "Left",
                                        Text = "Various",
                                        TextSize = 30,
                                        TextStrokeThickness = 2.3,
                                    },
                                },
                            }
                        },

                        scope:InteractionFrame {
                            LayoutOrder = 2,
                            BackgroundTransparency = 1,

                            Size = UDim2.fromOffset(245, 55),

                            GuiStateChanged = function(state: Enum.GuiState)
                                flagsButtonState:set(state)
                            end,

                            Children = scope:EmbossedFrame {
                                Size = UDim2.fromScale(1, 1),
                                Position = UDim2.fromScale(0.5, 0.5),
                                AnchorPoint = Vector2.new(0.5, 0.5),

                                Color = Color3.fromRGB(150, 134, 252),
                                
                                StrokeThickness = 2.5,
                                CornerRadius = UDim.new(0.25, 0),

                                Children = {
                                    scope:New "UIScale" {
                                        Scale = scope:Spring(flagsButtonSize, 35),
                                    },

                                    scope:IconText {
                                        Size = UDim2.fromScale(0.65, 0.80),
                                        Position = UDim2.fromScale(0.5, 0.5),
                                        AnchorPoint = Vector2.new(0.5, 0.5),

                                        Icon = Icons.ShoppingCart,
                                        IconSide = "Left",
                                        Text = "Flags",
                                        TextSize = 30,
                                        TextStrokeThickness = 2.3,
                                    },
                                },
                            }
                        },
                    },
                },
 
                scope:New "Frame" {
                    LayoutOrder = 2,

                    Size = UDim2.fromScale(1, 1),
                    Position = UDim2.fromScale(0.5, 0.5),
                    AnchorPoint = Vector2.new(0.5, 0.5),

                    BackgroundTransparency = 1,

                    [Children] = {
                        scope:New "UIListLayout" {
                            SortOrder = Enum.SortOrder.LayoutOrder,
                            FillDirection = Enum.FillDirection.Horizontal,
                            HorizontalFlex = Enum.UIFlexAlignment.Fill,
                        },

                        scope:New "Frame" {
                            LayoutOrder = 1,
                            BackgroundTransparency = 1,
                            
                            Size = UDim2.fromScale(0, 1),
                            
                            [Children] = {
                                scope:New "Frame" {
                                    LayoutOrder = 1,
                                    BackgroundTransparency = 1,

                                    Size = UDim2.fromScale(1, 0.9),
                                    Position = UDim2.fromScale(0.5, 0.5),
                                    AnchorPoint = Vector2.new(0.5, 0.5),

                                    [Children] = {
                                        scope:New "UIListLayout" {
                                            SortOrder = Enum.SortOrder.LayoutOrder,
                                            FillDirection = Enum.FillDirection.Vertical,
                                            VerticalFlex = Enum.UIFlexAlignment.Fill,

                                            Padding = UDim.new(0, 20),
                                        },
                                        
                                        scope:New "UIPadding" {
                                            PaddingLeft = UDim.new(0, 10),
                                            PaddingRight = UDim.new(0, 10),
                                        },

                                        scope:New "Frame" {
                                            Size = UDim2.fromScale(1, 1),
                                            SizeConstraint = Enum.SizeConstraint.RelativeXX,

                                            BackgroundTransparency = 1,

                                            [Children] = {
                                                scope:New "UIFlexItem" {
                                                    FlexMode = Enum.UIFlexMode.None,
                                                },

                                                scope:CosmeticPreview {
                                                    Size = UDim2.fromScale(1, 1),
                                                    Position = UDim2.fromScale(0.5, 0.5),
                                                    AnchorPoint = Vector2.new(0.5, 0.5),
                                                    
                                                    Icon = Icons.Aura,

                                                    Color = Color3.new(0.12, 0.54, 0.9),
                                                    
                                                    Title = "Skin Preview",
                                                    TextSize = 32,
                                                    
                                                    CornerRadius = UDim.new(0.18, 0),
                                                    Stroke = 4.5,
                                                },
                                            },
                                        },

                                        scope:New "Frame" {
                                            Size = UDim2.fromScale(1, 0),
                                            
                                            [Children] = {
                                                scope:New "UIListLayout" {
                                                    SortOrder = Enum.SortOrder.LayoutOrder,
                                                    FillDirection = Enum.FillDirection.Vertical,

                                                    VerticalFlex = Enum.UIFlexAlignment.Fill,
                                                    Padding = UDim.new(0, 20),
                                                },
                                                    
                                                scope:InteractionFrame {
                                                    Size = UDim2.fromScale(1, 0),

                                                    BackgroundTransparency = 1,

                                                    GuiStateChanged = function(state: Enum.GuiState)
                                                        equipButtonState:set(state)
                                                    end,

                                                    Children = scope:EmbossedFrame {
                                                        Size = UDim2.fromScale(1, 1),
                                                        Position = UDim2.fromScale(0.5, 0.5),
                                                        AnchorPoint = Vector2.new(0.5, 0.5),

                                                        Color = Color3.fromRGB(83, 250, 83),
                                                        CornerRadius = UDim.new(0.25, 0),
                                                        StrokeThickness = 2.5,

                                                        Children = {
                                                            scope:New "UIScale" {
                                                                Scale = scope:Spring(equipButtonSize, 35),
                                                            },

                                                            scope:New "TextLabel" {
                                                                Position = UDim2.fromScale(0.5, 0.5),
                                                                AnchorPoint = Vector2.new(0.5, 0.5),

                                                                Text = "Equip",
                                                                TextColor3 = Color3.new(1, 1, 1),
                                                                Font = Enum.Font.FredokaOne,
                                                                TextSize = 48,
                                                                
                                                                [Children] = scope:New "UIStroke" {
                                                                    Thickness = 2.0,
                                                                },
                                                            },
                                                        },
                                                    },
                                                },
                                            }
                                        },
                                    },
                                },
                            }
                        },

                        scope:New "ScrollingFrame" {
                            LayoutOrder = 2,
                            BackgroundTransparency = 1,

                            Size = scope:Computed(function(use)
                                return UDim2.new(0, use(itemsFrameWidth) + 50, 1, 0)
                            end),

                            [Children] = {
                                scope:New "UIFlexItem" {
                                    FlexMode = Enum.UIFlexMode.None,
                                },

                                scope:New "Frame" {
                                    Size = scope:Computed(function(use)
                                        return UDim2.new(0, use(itemsFrameWidth), 1, 0)
                                    end),

                                    Position = UDim2.fromScale(0.5, 0.5),
                                    AnchorPoint = Vector2.new(0.5, 0.5),
                                
                                    [Children] = {
                                        scope:New "UIPadding" {
                                            PaddingTop = UDim.new(0, 50),
                                        },

                                        scope:New "UIGridLayout" {
                                            CellSize = UDim2.fromOffset(ITEM_SIZE, ITEM_SIZE),
                                            CellPadding = UDim2.fromOffset(ITEM_PADDING, 2 * ITEM_PADDING),

                                            FillDirection = Enum.FillDirection.Horizontal,
                                            FillDirectionMaxCells = ITEMS_PER_ROW,
                                        },

                                        scope:ForValues(Range(12), function(use: Fusion.Use, scope: Scope<Components>, index: number)
                                            return scope:CosmeticShopCard {
                                                Color = Color3.new(0.047059, 1, 0.12549),
                                                
                                                Title = "Yellow",
                                                TextSize = 28,
                                                Icon = Icons.Aura,

                                                CurrencyIcon = Icons.Coin,
                                                CurrencyText = "1k",
                                                CurrencyTextSize = 28,

                                                CornerRadius = UDim.new(0.18, 0),
                                                Stroke = 3.0,
                                            }
                                        end),
                                    } :: {Fusion.Child}
                                }
                            }
                        },
                    },
                },
            }
        }
    }
end

return SkinsWindow
