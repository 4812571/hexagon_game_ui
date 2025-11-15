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
local Text = require(Client.Interface.Text)
local ButtonFrame = require(Client.Interface.ButtonFrame)

type Scope<T> = Fusion.Scope<typeof(Fusion) & T>

type Components = {
    Icon: typeof(Icon),
    Text: typeof(Text),
    ButtonFrame: typeof(ButtonFrame),
}

export type BombCardProps = {
    Size: Fusion.UsedAs<UDim2>?,
    Position: Fusion.UsedAs<UDim2>?,
    AnchorPoint: Fusion.UsedAs<Vector2>?,
    
    Count: Fusion.UsedAs<number>,
    BombIcon: Fusion.UsedAs<string>,
    Transparency: Fusion.UsedAs<number>?,
    Gradient: Fusion.Child?,
    
    Cooldown: Fusion.UsedAs<number>,
    Activated: (() -> ())?,
}

local function BombCard<U>(scope: Scope<U>, props: BombCardProps)
    local scope: Scope<Components> = scope:innerScope {
        Icon = Icon,
        Text = Text,
        ButtonFrame = ButtonFrame,
    }

    local isCooldown = scope:Computed(function(use)
        return use(props.Cooldown) > 0
    end)

    return scope:New "Frame" {
        Size = props.Size,
        Position = props.Position,
        AnchorPoint = props.AnchorPoint,

        BackgroundTransparency = 1,

        [Children] = scope:ButtonFrame {
            Size = UDim2.fromScale(1, 1),
            Position = UDim2.fromScale(0.5, 0.5),
            AnchorPoint = Vector2.new(0.5, 0.5),

            BackgroundTransparency = 1,

            Scaling = {
                Idle = 1.0,
                Hover = 1.1,
                Press = 0.9,
            },

            Activated = props.Activated,

            Children = {
                scope:New "ImageLabel" {
                    Size = UDim2.fromScale(1, 1),
                    Position = UDim2.fromScale(0.5, 0.5),
                    AnchorPoint = Vector2.new(0.5, 0.5),

                    Image = Icons.Hexagon,
                    ImageTransparency = props.Transparency,
                    BackgroundTransparency = 1,

                    [Children] = {
                        props.Gradient,

                        scope:Icon {
                            Size = UDim2.fromScale(0.75, 0.75),
                            Position = UDim2.fromScale(0.5, 0.5),
                            AnchorPoint = Vector2.new(0.5, 0.5),

                            Color = scope:Computed(function(use)
                                return if use(isCooldown) then Color3.new(0.5, 0.5, 0.5) else Color3.new(1, 1, 1)
                            end),

                            Icon = props.BombIcon,
                        },

                        scope:Text {
                            Size = UDim2.fromScale(1, 0.3),
                            Position = UDim2.fromScale(0.5, 0.5),
                            AnchorPoint = Vector2.new(0.5, 0.5),

                            Text = scope:Computed(function(use)
                                if not use(isCooldown) then
                                    return ""
                                end

                                return string.format("%.1fs", use(props.Cooldown))
                            end),

                            TextSize = 60,

                            TextXAlignment = Enum.TextXAlignment.Center,
                            TextYAlignment = Enum.TextYAlignment.Center,
                            StrokeSize = 2.5,
                        },

                        scope:Text {
                            Size = UDim2.fromScale(1, 0.3),
                            Position = UDim2.fromScale(0.5, 0.80),
                            AnchorPoint = Vector2.new(0.5, 0.5),

                            Text = scope:Computed(function(use)
                                return `x{use(props.Count)}`
                            end),

                            TextSize = 42,
                            TextXAlignment = Enum.TextXAlignment.Center,
                            TextYAlignment = Enum.TextYAlignment.Center,
                            StrokeSize = 2.5,
                        },
                    } :: {Fusion.Child?},
                },
            } :: {Fusion.Child},
        },
    }
end

return BombCard