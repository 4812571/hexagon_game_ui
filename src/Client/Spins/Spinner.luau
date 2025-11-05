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

local Clock = require(Common.Util.Clock)
local Text = require(Client.Interface.Text)

local SpinnerIcon = require(Client.Spins.SpinnerIcon)

local TAU = math.pi * 2

local function ToUDimFromCenter(v: Vector3)
    return UDim2.fromScale((v.X + 1.0) / 2.0, (v.Y + 1.0) / 2.0)
end

export type Scope<T> = Fusion.Scope<typeof(Fusion) & T>

export type Components = {
    Clock: typeof(Clock),
    Text: typeof(Text),
    SpinnerIcon: typeof(SpinnerIcon),
}

export type SpinnerItemProps = {
    Icon: string,
    Text: string,
    Percentage: number,
}

export type SpinnerProps = {
    Size: Fusion.UsedAs<UDim2>?,
    Position: Fusion.UsedAs<UDim2>?,
    AnchorPoint: Fusion.UsedAs<Vector2>?,

    Rotation: Fusion.UsedAs<number>,
    PercentagesVisible: Fusion.UsedAs<boolean>,
    Items: Fusion.UsedAs<{SpinnerItemProps}>,
}

local function Range(count: number)
    local result = {}

    for i = 0, count - 1 do
        table.insert(result, i)
    end

    return result
end

export type Positioning = {
    Index: number,
    Position: Vector3,
    UnitRotation: number,
}

local function Spinner<U>(scope: Scope<U>, props: SpinnerProps)
    local scope: Scope<Components> = scope:innerScope {
        Clock = Clock,
        Text = Text,
        SpinnerIcon = SpinnerIcon,
    }

    local COUNT = 8

    local positionings: Fusion.UsedAs<{Positioning}> = scope:ForValues(Range(COUNT), function(use: Fusion.Use, scope: Scope<Components>, index: number)
        -- Note: +0.5 to center the icons on their segments
        local unitRotation = (index + 0.5) / COUNT

        local x = math.cos(unitRotation * TAU)
        local y = math.sin(unitRotation * TAU)
        
        local positioning: Positioning = {
            Index = index,
            Position = Vector3.new(x, y, 0),
            UnitRotation = unitRotation,
        }

        return positioning
    end)

    local icons = scope:ForValues(positionings, function(use: Fusion.Use, scope: Scope<Components>, positioning: Positioning)
        local item: SpinnerItemProps = use(props.Items)[positioning.Index + 1]
        
        return scope:New "Frame" {
            Size = UDim2.fromScale(0.125, 0.125),
            Position = ToUDimFromCenter(positioning.Position * 0.525),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Rotation = (360 * positioning.UnitRotation) + 90,

            BackgroundTransparency = 1,

            [Children] = scope:SpinnerIcon {
                Size = UDim2.fromScale(1, 1),
                Position = UDim2.fromScale(0.5, 0.5),
                AnchorPoint = Vector2.new(0.5, 0.5),

                Icon = item.Icon,
                Text = item.Text,
            }
        }
    end)

    local texts = scope:ForValues(positionings, function(use: Fusion.Use, scope: Scope<Components>, positioning: Positioning)
        local item: SpinnerItemProps = use(props.Items)[positioning.Index + 1]
        
        return scope:Text {
            Size = UDim2.fromScale(0.15, 0.05),
            Position = ToUDimFromCenter(positioning.Position * 0.732),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Rotation = (360 * positioning.UnitRotation) + 90,
            Visible = props.PercentagesVisible,

            BackgroundTransparency = 1,
            Text = tostring(item.Percentage) .. "%",

            TextColor3 = Color3.new(1, 1, 1),
            TextSize = 18,
            Font = Enum.Font.FredokaOne,
        }
    end)

    return scope:New "Frame" {
        Size = UDim2.fromOffset(500, 500),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),

        BackgroundColor3 = Color3.new(0, 0, 0),

        [Children] = {
            scope:New "UICorner" {
                CornerRadius = UDim.new(1, 0),
            },

            scope:New "ImageLabel" {
                Size = UDim2.fromScale(1.30, 1.30),
                Position = UDim2.fromScale(0.5, 0.5),
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundTransparency = 1,
                Image = Icons.BorderlessSpinnerHighRes,
                Rotation = props.Rotation,

                [Children] = {
                    icons,
                    texts,

                    scope:New "Frame" {
                        Size = UDim2.fromScale(0.125, 0.125),
                        Position = UDim2.fromScale(0.5, 0.5),
                        AnchorPoint = Vector2.new(0.5, 0.5),

                        BackgroundColor3 = Color3.new(1, 1, 1),

                        [Children] = {
                            scope:New "UICorner" {
                                CornerRadius = UDim.new(1, 0),
                            },

                            scope:New "UIStroke" {
                                Thickness = 4,
                                Color = Color3.new(0, 0, 0),
                            },
                        },
                    },
                } :: {Fusion.Child}
            }       
        },
    }
end

return Spinner