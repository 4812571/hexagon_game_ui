--!strict
--!native
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

local ButtonFrame = require(Client.Interface.ButtonFrame)
local EmbossedFrame = require(Client.Interface.EmbossedFrame)
local Icon = require(Client.Interface.Icon)
local Text = require(Client.Interface.Text)

local TAU = math.pi * 2

local function UnitSin(t: number): number
    return 0.5 * (math.sin(t * TAU) + 1)
end

local CORNER_RADIUS = UDim.new(0, 32)
local STROKE_THICKNESS = 5.5

local NEW_INDICATOR_FREQUENCY = 1
local NEW_INDICATOR_AMPLITUDE = 0.45
local NEW_INDICATOR_BASE_SCALE = 0.65

export type Components = {
    ButtonFrame: typeof(ButtonFrame),
    EmbossedFrame: typeof(EmbossedFrame),
    Icon: typeof(Icon),
    Text: typeof(Text),
}

export type SidebarSquareButtonProps = {
    Size: Fusion.UsedAs<UDim2>?,
    Position: Fusion.UsedAs<UDim2>?,
    AnchorPoint: Fusion.UsedAs<Vector2>?,

    Index: number,

    Icon: Fusion.UsedAs<string>,
    Text: Fusion.UsedAs<string>,
    Color: Fusion.UsedAs<Color3>,
    IsNew: Fusion.UsedAs<boolean>?,

    Activated: () -> (),
}

local function SidebarSquareButton<U>(scope: Scope<U>, props: SidebarSquareButtonProps)
    local scope: Scope<Components> = scope:innerScope {
        ButtonFrame = ButtonFrame,
        EmbossedFrame = EmbossedFrame,
        Icon = Icon,
        Text = Text,
    }

    local currentTime = Clock(scope)

    local newIndicatorScale = scope:Computed(function(use)
        local now: number = use(currentTime) :: number
        local sinValue = UnitSin(now * NEW_INDICATOR_FREQUENCY)
        return NEW_INDICATOR_BASE_SCALE * (1 + sinValue * NEW_INDICATOR_AMPLITUDE)
    end)
    
    local newLabel = scope:Computed(function(use, scope: Scope<Components>): Fusion.Child
        if not use(props.IsNew) then
            return {}
        end

        return scope:Text {
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
            StrokeSize = 4,

            [Children] = scope:New "UIScale" {
                Scale = scope:Computed(function(use)
                    return use(newIndicatorScale)
                end),
            },
        }
    end)

    return scope:New "Frame" {
        Name = "SidebarSquareButton",

        Size = UDim2.fromOffset(200, 200),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),

        LayoutOrder = props.Index,
        ZIndex = -props.Index,

        BackgroundTransparency = 1,

        [Children] = {
            scope:ButtonFrame {
                Name = "SidebarSquareButton",

                Size = UDim2.fromOffset(200, 200),
                Position = UDim2.fromScale(0.5, 0.5),
                AnchorPoint = Vector2.new(0.5, 0.5),

                BackgroundTransparency = 1,

                Scaling = {
                    Idle = 1.0,
                    Hover = 1.04,
                    Press = 0.965,
                },

                Activated = props.Activated,

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

                    scope:Text {
                        Size = UDim2.fromScale(1, 0.2),
                        Position = UDim2.fromScale(0.5, 0.97),

                        Text = props.Text,
                        TextSize = 55,
                        
                        StrokeThickness = 4.0,
                    },
                } :: {Fusion.Child}
            },
        },
    }
end

return SidebarSquareButton
