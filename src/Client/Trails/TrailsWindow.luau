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
local Trails = require(Common.Trails.Trails)

local Text = require(Client.Interface.Text)
local Window = require(Client.Interface.Window)
local ButtonFrame = require(Client.Interface.ButtonFrame)
local EmbossedFrame = require(Client.Interface.EmbossedFrame)

local CosmeticPreview = require(Client.Cosmetics.CosmeticPreview)
local CosmeticShopCard = require(Client.Cosmetics.CosmeticShopCard)

type Scope<T> = Fusion.Scope<typeof(Fusion) & T>

export type Components = {
    Text: typeof(Text),
    Window: typeof(Window),
    ButtonFrame: typeof(ButtonFrame),
    EmbossedFrame: typeof(EmbossedFrame),

    CosmeticPreview: typeof(CosmeticPreview),
    CosmeticShopCard: typeof(CosmeticShopCard),
}

export type TrailsWindowProps = {
    Scale: Fusion.UsedAs<number>,
    Visible: Fusion.UsedAs<boolean>,
    
    SelectedTrail: Fusion.UsedAs<Trails.TrailEntry>,
    Trails: Fusion.UsedAs<{Trails.TrailEntry}>,
    
    EquippedTrail: Fusion.UsedAs<string?>,
    OwnedTrails: Fusion.UsedAs<{[string]: boolean}>,
    
    OnClose: () -> (),
    OnTrailSelected: (trail: Trails.TrailEntry) -> (),
    OnPurchase: (trail: Trails.TrailEntry) -> (),
    OnEquip: (trail: Trails.TrailEntry?) -> (),
}

local function PriceIcon(price: Trails.TrailPrice): string
    if price.Currency == "Coins" then
        return Icons.Coin
    end

    if price.Currency == "Robux" then
        return Icons.Robux
    end

    error("Unknown currency: " .. price.Currency)
end

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

local function TrailsWindow<U>(scope: Scope<U>, props: TrailsWindowProps)
    local scope: Scope<Components> = scope:innerScope {
        Text = Text,
        Window = Window,
        ButtonFrame = ButtonFrame,
        EmbossedFrame = EmbossedFrame,

        CosmeticPreview = CosmeticPreview,
        CosmeticShopCard = CosmeticShopCard,
    }

    local ITEM_SIZE = 125
    local ITEM_PADDING = 10

    local ITEMS_PER_ROW = 3

    local itemsFrameWidth = scope:Computed(function(use)
        return PaddedSize(use(ITEMS_PER_ROW), use(ITEM_SIZE), use(ITEM_PADDING))
    end)

    local isOwned = scope:Computed(function(use)
        return use(props.OwnedTrails)[use(props.SelectedTrail).Id] == true
    end)

    return scope:Window {
        Title = "Trails",
        Icon = Icons.Aura,
        Visible = props.Visible,
        IconScale = 1.45,

        OnClose = props.OnClose,

        Children = {
            scope:New "UIScale" {
                Scale = props.Scale,
            },

            scope:New "Frame" {
                Size = UDim2.fromScale(0.9, 1),
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
                                                    Type = "Color",

                                                    Icon = scope:Computed(function(use)
                                                        return use(props.SelectedTrail).Icon
                                                    end),

                                                    Color = scope:Computed(function(use)
                                                        return use(props.SelectedTrail).ThemeColor
                                                    end),
                                                },
                                                
                                                Title = scope:Computed(function(use)
                                                    return use(props.SelectedTrail).Id
                                                end),

                                                TextSize = 52,
                                                
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
                                                
                                            scope:New "Frame" {
                                                Size = UDim2.fromScale(1, 0),
                                                
                                                [Children] = scope:ButtonFrame {
                                                    Size = UDim2.fromScale(1, 1),
                                                    Position = UDim2.fromScale(0.5, 0.5),
                                                    AnchorPoint = Vector2.new(0.5, 0.5),

                                                    BackgroundTransparency = 1,

                                                    Scaling = {
                                                        Idle = 1.0,
                                                        Hover = 1.05,
                                                        Press = 0.95,
                                                    },

                                                    Activated = function()
                                                        if not peek(isOwned) then
                                                            props.OnPurchase(peek(props.SelectedTrail))
                                                        end

                                                        if peek(isOwned) then
                                                            if peek(props.EquippedTrail) == peek(props.SelectedTrail).Id then
                                                                props.OnEquip(nil)
                                                            else
                                                                props.OnEquip(peek(props.SelectedTrail))
                                                            end
                                                        end
                                                    end,

                                                    Children = scope:EmbossedFrame {
                                                        Size = UDim2.fromScale(1, 1),
                                                        Position = UDim2.fromScale(0.5, 0.5),
                                                        AnchorPoint = Vector2.new(0.5, 0.5),

                                                        Color = Color3.fromRGB(83, 250, 83),
                                                        CornerRadius = UDim.new(0.25, 0),
                                                        StrokeThickness = 2.5,

                                                        Children = scope:Text {
                                                            Text = scope:Computed(function(use)
                                                                if not use(isOwned) then
                                                                    return "Buy"
                                                                end

                                                                if use(props.EquippedTrail) == use(props.SelectedTrail).Id then
                                                                    return "Equipped"
                                                                end

                                                                return "Equip"
                                                            end),

                                                            TextSize = 48,
                                                            StrokeSize = 2.0,
                                                        },
                                                    },
                                                },
                                            },

                                            scope:New "Frame" {
                                                Size = UDim2.fromScale(1, 0),
                                                
                                                [Children] = scope:ButtonFrame {
                                                    Size = UDim2.fromScale(1, 1),
                                                    Position = UDim2.fromScale(0.5, 0.5),
                                                    AnchorPoint = Vector2.new(0.5, 0.5),

                                                    BackgroundTransparency = 1,

                                                    Scaling = {
                                                        Idle = 1.0,
                                                        Hover = 1.05,
                                                        Press = 0.95,
                                                    },
                                                
                                                    Children = scope:EmbossedFrame {
                                                        Size = UDim2.fromScale(1, 1),
                                                        Position = UDim2.fromScale(0.5, 0.5),
                                                        AnchorPoint = Vector2.new(0.5, 0.5),

                                                        Color = Color3.fromRGB(255, 95, 67),
                                                        CornerRadius = UDim.new(0.25, 0),
                                                        StrokeThickness = 2.5,

                                                        Children = scope:Text {
                                                            Text = "Pay me money!",
                                                            TextSize = 48,
                                                            StrokeSize = 2.0,
                                                        },
                                                    },
                                                },
                                            }
                                        },
                                    },
                                },
                            },
                        },
                    },

                    scope:New "ScrollingFrame" {
                        LayoutOrder = 2,
                        BackgroundTransparency = 1,

                        AutomaticCanvasSize = Enum.AutomaticSize.Y,

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
                                        PaddingBottom = UDim.new(0, 50),
                                    },

                                    scope:New "UIGridLayout" {
                                        CellSize = UDim2.fromOffset(ITEM_SIZE, ITEM_SIZE),
                                        CellPadding = UDim2.fromOffset(ITEM_PADDING, 2 * ITEM_PADDING),

                                        FillDirection = Enum.FillDirection.Horizontal,
                                        FillDirectionMaxCells = ITEMS_PER_ROW,
                                    },

                                    scope:ForPairs(props.Trails, function(use: Fusion.Use, scope: Scope<Components>, index: number, trail: Trails.TrailEntry)
                                        return index, scope:CosmeticShopCard {
                                            Background = {
                                                Type = "Color",
                                                Icon = trail.Icon,
                                                Color = trail.ThemeColor,
                                            },

                                            Owned = scope:Computed(function(use)
                                                return use(props.OwnedTrails)[trail.Id] == true
                                            end),

                                            Title = trail.Id,
                                            TextSize = 28,

                                            CurrencyIcon = PriceIcon(trail.Price),
                                            CurrencyText = FormatNumber(trail.Price.Amount),
                                            CurrencyTextSize = 28,

                                            CornerRadius = UDim.new(0.18, 0),
                                            Stroke = 3.0,

                                            Activated = function()
                                                props.OnTrailSelected(trail)
                                            end,
                                        }
                                    end),
                                } :: {Fusion.Child}
                            },
                        },
                    },
                },
            },
        }
    }
end

return TrailsWindow
