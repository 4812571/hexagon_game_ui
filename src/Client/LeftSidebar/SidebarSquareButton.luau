--!strict
--!nolint LocalShadow

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)
local Children = Fusion.Children

local Clock = require(Common.Util.Clock)

type Scope<T> = Fusion.Scope<typeof(Fusion) & T>
type UsedAs<T> = Fusion.UsedAs<T>

local InteractionFrame = require(Client.Interface.InteractionFrame)
local EmbossedFrame = require(Client.Interface.EmbossedFrame)
local Icon = require(Client.Interface.Icon)

local TAU = math.pi * 2

local function UnitSin(t: number): number
    return 0.5 * (math.sin(t * TAU) + 1)
end

local CORNER_RADIUS = UDim.new(0, 32)
local STROKE_THICKNESS = 5.5

local HOVER_SCALE = 1.04
local PRESS_SCALE = 0.965

local NEW_INDICATOR_FREQUENCY = 1
local NEW_INDICATOR_AMPLITUDE = 0.45
local NEW_INDICATOR_BASE_SCALE = 0.65
    
export type SidebarSquareButtonProps = {
    Size: Fusion.UsedAs<UDim2>?,
    Position: Fusion.UsedAs<UDim2>?,
    AnchorPoint: Fusion.UsedAs<Vector2>?,

    Icon: Fusion.UsedAs<string>,
    Text: Fusion.UsedAs<string>,
    Color: Fusion.UsedAs<Color3>,
    IsNew: Fusion.UsedAs<boolean>?,
}

local function SidebarSquareButton<U>(scope: Scope<U>, props: SidebarSquareButtonProps)
    local scope = scope:innerScope {
        InteractionFrame = InteractionFrame,
        EmbossedFrame = EmbossedFrame,
        Icon = Icon,
    }

    local guiState = scope:Value(Enum.GuiState.NonInteractable)

    local scale = scope:Computed(function(use)
        if use (guiState) == Enum.GuiState.Hover then
            return HOVER_SCALE
        end

        if use (guiState) == Enum.GuiState.Press then
            return PRESS_SCALE
        end

        return 1
    end)

    local currentTime = Clock(scope)

    local newIndicatorScale = scope:Computed(function(use)
        local now: number = use(currentTime) :: number
        local sinValue = UnitSin(now * NEW_INDICATOR_FREQUENCY)
        return NEW_INDICATOR_BASE_SCALE * (1 + sinValue * NEW_INDICATOR_AMPLITUDE)
    end)
    
    local newLabel = scope:Computed(function(use, scope: Scope<U>): Fusion.Child
        if not use(props.IsNew) then
            return {}
        end

        return scope:New "TextLabel" {
            Size = UDim2.fromScale(1, 0.2),
            Position = UDim2.fromScale(0.9, 0.1),
            AnchorPoint = Vector2.new(0.5, 0.5),

            Text = "New!",
            TextSize = 55,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            FontFace = Font.fromEnum(Enum.Font.FredokaOne),
            BackgroundTransparency = 1,
            Rotation = 25,

            ZIndex = 2,

            [Children] = {
                scope:New "UIStroke" {
                    Thickness = 4,
                    Color = Color3.fromRGB(0, 0, 0),
                    Transparency = 0,
                },

                scope:New "UIScale" {
                    Scale = scope:Computed(function(use)
                        return use(newIndicatorScale)
                    end),
                },
            }
        }
    end)

    return scope:New "Frame" {
        Name = "SidebarSquareButton",

        Size = UDim2.fromOffset(200, 200),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),

        BackgroundTransparency = 1,

        [Children] = {
            scope:InteractionFrame {
                Name = "SidebarSquareButton",

                Size = UDim2.fromOffset(200, 200),
                Position = UDim2.fromScale(0.5, 0.5),
                AnchorPoint = Vector2.new(0.5, 0.5),

                BackgroundTransparency = 1,

                GuiStateChanged = function(state: Enum.GuiState)
                    guiState:set(state)
                end,

                Children = {
                    newLabel,

                    scope:EmbossedFrame {
                        Size = UDim2.fromScale(1, 1),
                        CornerRadius = CORNER_RADIUS,

                        StrokeColor = Color3.new(0, 0, 0),
                        StrokeThickness = STROKE_THICKNESS,

                        Color = props.Color,

                        Children = {
                            scope:Icon {
                                Size = UDim2.fromScale(0.8, 0.8),
                                Position = UDim2.fromScale(0.5, 0.5),
                                AnchorPoint = Vector2.new(0.5, 0.5),

                                ZIndex = 2,

                                Icon = props.Icon,
                            },
                        },
                    },

                    scope:New "TextLabel" {
                        Size = UDim2.fromScale(1, 0.2),
                        Position = UDim2.fromScale(0.5, 0.97),
                        AnchorPoint = Vector2.new(0.5, 0.5),

                        Text = props.Text,
                        TextSize = 55,
                        TextColor3 = Color3.fromRGB(255, 255, 255),
                        FontFace = Font.fromEnum(Enum.Font.FredokaOne),
                        BackgroundTransparency = 1,

                        [Children] = scope:New "UIStroke" {
                            Thickness = 4,
                            Color = Color3.fromRGB(0, 0, 0),
                            Transparency = 0,
                        },
                    },

                    scope:New "UIScale" {
                        Scale = scope:Spring(scale, 45),
                    },
                } :: {Fusion.Child}
            },
        },
    }
end

return SidebarSquareButton