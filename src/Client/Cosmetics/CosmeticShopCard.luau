--!strict
--!native
--!nolint LocalShadow

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)
local Children = Fusion.Children

local IconText = require(Client.Interface.IconText)
local InteractionFrame = require(Client.Interface.InteractionFrame)
local CosmeticPreview = require(Client.Cosmetics.CosmeticPreview)

type Scope<T> = Fusion.Scope<typeof(Fusion) & T>

export type Components = {
    IconText: typeof(IconText),
    InteractionFrame: typeof(InteractionFrame),
    CosmeticPreview: typeof(CosmeticPreview),
}

export type CosmeticShopCardProps = {
    Size: Fusion.UsedAs<UDim2>?,
    Position: Fusion.UsedAs<UDim2>?,
    AnchorPoint: Fusion.UsedAs<Vector2>?,

    Icon: Fusion.UsedAs<string>,
    Title: Fusion.UsedAs<string>,
    TextSize: Fusion.UsedAs<number>,
    Color: Fusion.UsedAs<Color3>,

    CurrencyText: Fusion.UsedAs<string>,
    CurrencyTextSize: Fusion.UsedAs<number>,
    CurrencyIcon: Fusion.UsedAs<string>,

    CornerRadius: Fusion.UsedAs<UDim>,
    Stroke: Fusion.UsedAs<number>,

    Activated: (() -> ())?,
}

local function CosmeticShopCard<U>(scope: Scope<U>, props: CosmeticShopCardProps)
    local scope: Scope<Components> = scope:innerScope {
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

                    Icon = props.Icon,
                    Title = props.Title,
                    TextSize = props.TextSize,
                    Color = props.Color,

                    CornerRadius = props.CornerRadius,
                    Stroke = props.Stroke,

                    Children = scope:IconText {
                        Size = UDim2.fromScale(0.95, 0.25),
                        AnchorPoint = Vector2.new(0, 1),
                        Position = UDim2.fromScale(0.0, 0.95),

                        IconSide = "Right",

                        Text = props.CurrencyText,
                        TextStrokeThickness = 3.5,
                        TextSize = props.CurrencyTextSize,
                        Icon = props.CurrencyIcon,
                    },
                },
            }
        },
        
        Activated = props.Activated,
    
        GuiStateChanged = function(state: Enum.GuiState)
            guiState:set(state)
        end,
    }
end

return CosmeticShopCard