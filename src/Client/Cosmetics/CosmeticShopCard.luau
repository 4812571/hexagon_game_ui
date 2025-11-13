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

local Icon = require(Client.Interface.Icon)
local IconText = require(Client.Interface.IconText)
local InteractionFrame = require(Client.Interface.InteractionFrame)
local CosmeticPreview = require(Client.Cosmetics.CosmeticPreview)

type Scope<T> = Fusion.Scope<typeof(Fusion) & T>

export type Components = {
    Icon: typeof(Icon),
    IconText: typeof(IconText),
    InteractionFrame: typeof(InteractionFrame),
    CosmeticPreview: typeof(CosmeticPreview),
}

export type CosmeticShopCardProps = {
    Size: Fusion.UsedAs<UDim2>?,
    Position: Fusion.UsedAs<UDim2>?,
    AnchorPoint: Fusion.UsedAs<Vector2>?,

    Background: CosmeticPreview.BackgroundProps,

    Title: Fusion.UsedAs<string>,
    TextSize: Fusion.UsedAs<number>,

    CurrencyText: Fusion.UsedAs<string>,
    CurrencyTextSize: Fusion.UsedAs<number>,
    CurrencyIcon: Fusion.UsedAs<string>,

    CornerRadius: Fusion.UsedAs<UDim>,
    Stroke: Fusion.UsedAs<number>,

    Owned: Fusion.UsedAs<boolean>,

    Activated: (() -> ())?,
}

local function CosmeticShopCard<U>(scope: Scope<U>, props: CosmeticShopCardProps)
    local scope: Scope<Components> = scope:innerScope {
        Icon = Icon,
        IconText = IconText,
        InteractionFrame = InteractionFrame,
        CosmeticPreview = CosmeticPreview,
    }

    local guiState = scope:Value(Enum.GuiState.NonInteractable)

    local scale = scope:Computed(function(use)
        if use(guiState) == Enum.GuiState.Hover then
            return 0.95
        end

        if use(guiState) == Enum.GuiState.Press then
            return 0.90
        end

        return 1.0
    end)

    local checkScale = scope:Computed(function(use)
        return if use(props.Owned) then 1.0 else 0.0
    end)

    return scope:InteractionFrame {
        Size = props.Size,
        Position = props.Position,
        AnchorPoint = props.AnchorPoint,

        BackgroundTransparency = 1,

        Children = scope:New "Frame" {
            Size = UDim2.fromScale(1, 1),
            Position = UDim2.fromScale(0.5, 0.5),
            AnchorPoint = Vector2.new(0.5, 0.5),

            BackgroundTransparency = 1,

            [Children] = {
                scope:New "UIScale" {
                    Scale = scope:Spring(scale, 35),
                },

                scope:CosmeticPreview {
                    Size = UDim2.fromScale(1, 1),
                    Position = UDim2.fromScale(0.5, 0.5),
                    AnchorPoint = Vector2.new(0.5, 0.5),

                    Title = props.Title,
                    TextSize = props.TextSize,
                    Background = props.Background,

                    CornerRadius = props.CornerRadius,
                    Stroke = props.Stroke,

                    Children = {
                        scope:IconText {
                            Size = UDim2.fromScale(0.95, 0.25),
                            AnchorPoint = Vector2.new(0, 1),
                            Position = UDim2.fromScale(0.0, 0.95),

                            IconSide = "Right",

                            Text = props.CurrencyText,
                            TextStrokeThickness = 3.5,
                            TextSize = props.CurrencyTextSize,
                            Icon = props.CurrencyIcon,
                        },

                        scope:Icon {
                            Size = UDim2.fromScale(0.65, 0.65),
                            Position = UDim2.fromScale(0.5, 0.45),
                            AnchorPoint = Vector2.new(0.5, 0.5),

                            Icon = Icons.Check,

                            Children = scope:New "UIScale" {
                                Scale = scope:Spring(checkScale, 35, 0.40),
                            }
                        },
                    }
                },
            } :: {Fusion.Child?}
        },
        
        Activated = props.Activated,
    
        GuiStateChanged = function(state: Enum.GuiState)
            guiState:set(state)
        end,
    }
end

return CosmeticShopCard