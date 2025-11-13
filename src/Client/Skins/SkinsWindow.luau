--!strict
--!native
--!nolint LocalShadow

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)
local Children = Fusion.Children
local peek = Fusion.peek

local Icons = require(Common.Icons)
local Skins = require(Common.Skins.Skins)

local Window = require(Client.Interface.Window)
local InteractionFrame = require(Client.Interface.InteractionFrame)
local EmbossedFrame = require(Client.Interface.EmbossedFrame)
local IconText = require(Client.Interface.IconText)
local Text = require(Client.Interface.Text)

local CosmeticPreview = require(Client.Cosmetics.CosmeticPreview)
local CosmeticShopCard = require(Client.Cosmetics.CosmeticShopCard)

type Scope<T> = Fusion.Scope<typeof(Fusion) & T>

export type Components = {
    Window: typeof(Window),
    InteractionFrame: typeof(InteractionFrame),
    EmbossedFrame: typeof(EmbossedFrame),
    IconText: typeof(IconText),
    Text: typeof(Text),

    CosmeticPreview: typeof(CosmeticPreview),
    CosmeticShopCard: typeof(CosmeticShopCard),
}

export type SkinEntry = {
    Owned: Fusion.UsedAs<boolean>,
    Skin: Skins.SkinInfo,
}

export type SkinSection = "Various" | "Flags"

export type SkinsWindowProps = {
    Scale: Fusion.UsedAs<number>,
    Visible: Fusion.UsedAs<boolean>,

    Section: Fusion.UsedAs<SkinSection>,
    Skins: Fusion.UsedAs<{SkinEntry}>,
    Selected: Fusion.UsedAs<SkinEntry>,
    Equipped: Fusion.UsedAs<Skins.SkinInfo?>,

    OnClose: () -> (),
    OnSelect: (SkinEntry) -> (),
    OnPurchase: (SkinEntry) -> (),
    OnEquip: (SkinEntry?) -> (),
}

local function FormatNumber(n: number): string
    local UNITS = { "", "k", "M", "B", "T" }
    local sign = n < 0 and "-" or ""
    local absn = math.abs(n)

    -- Choose unit
    local unitIdx = 1
    while absn >= 1000 and unitIdx < #UNITS do
        absn /= 1000
        unitIdx += 1
    end

    -- For plain numbers (no suffix), keep them tidy (no decimals if whole)
    if unitIdx == 1 then
        if absn == math.floor(absn) then
            return sign .. tostring(math.floor(absn))
        else
            local s = string.format("%.1f", absn):gsub("%.0$", "")
            return sign .. s
        end
    end

    -- Format with one decimal for suffixed numbers
    local s = string.format("%.1f", absn):gsub("%.0$", "")

    -- Handle rounding overflow like 999.95 -> "1000" (promote unit)
    local numeric = tonumber(s)
    if numeric and numeric >= 1000 and unitIdx < #UNITS then
        s = "1"              -- becomes exactly 1 of the next unit
        unitIdx += 1
    end

    return sign .. s .. UNITS[unitIdx]
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
        Text = Text,

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

    local currentSkinState = scope:Computed(function(use)
        local selected = use(props.Selected)

        if not use(selected.Owned) then
            return "NotOwned"
        end

        if use(props.Equipped) == selected.Skin then
            return "Equipped"
        end

        return "Owned"
    end)

    return scope:Window {
        Title = "Skins",
        Icon = Icons.Aura,
        IconScale = 1.45,
        Visible = props.Visible,

        OnClose = props.OnClose,

        Children = {
            scope:New "UIScale" {
                Scale = scope:Spring(props.Scale, 35),
            },

            scope:New "Frame" {
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
                                                        
                                                        Background = {
                                                            Type = "Image",

                                                            Image = scope:Computed(function(use)
                                                                return use(props.Selected).Skin.ImageId
                                                            end),
                                                        },

                                                        Title = scope:Computed(function(use)
                                                            return use(props.Selected).Skin.Name
                                                        end),

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

                                                        Activated = function()
                                                            if peek(currentSkinState) == "NotOwned" then
                                                                return props.OnPurchase(peek(props.Selected))
                                                            end

                                                            if peek(currentSkinState) == "Owned" then
                                                                return props.OnEquip(peek(props.Selected))
                                                            end

                                                            if peek(currentSkinState) == "Equipped" then
                                                                return props.OnEquip(nil)
                                                            end
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

                                                                scope:Text {
                                                                    Position = UDim2.fromScale(0.5, 0.5),
                                                                    AnchorPoint = Vector2.new(0.5, 0.5),

                                                                    Text = scope:Computed(function(use)
                                                                        if use(currentSkinState) == "NotOwned" then
                                                                            return "Buy"
                                                                        end

                                                                        if use(currentSkinState) == "Owned" then
                                                                            return "Equip"
                                                                        end

                                                                        if use(currentSkinState) == "Equipped" then
                                                                            return "Unequip"
                                                                        end

                                                                        error("Unknown skin state")
                                                                    end),
                                                                    TextSize = 48,

                                                                    StrokeSize = 2.0,
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

                                            scope:ForPairs(props.Skins, function(use: Fusion.Use, scope: Scope<Components>, index: number, skinEntry: SkinEntry)                                               
                                                return index, scope:CosmeticShopCard {
                                                    Background = {
                                                        Type = "Image",
                                                        Image = skinEntry.Skin.ImageId,
                                                    },

                                                    Title = skinEntry.Skin.Name,
                                                    TextSize = 28,

                                                    CurrencyIcon = Icons.Coin,
                                                    CurrencyText = FormatNumber(skinEntry.Skin.Price),
                                                    CurrencyTextSize = 28,

                                                    CornerRadius = UDim.new(0.18, 0),
                                                    Stroke = 3.0,

                                                    Owned = skinEntry.Owned,

                                                    Activated = function()
                                                        props.OnSelect(skinEntry)
                                                    end,
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
    }
end

return SkinsWindow
