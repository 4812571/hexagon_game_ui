--!strict
--!native
--!nolint LocalShadow

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)
local Children = Fusion.Children

local Icon = require(Client.Interface.Icon)
local Text = require(Client.Interface.Text)
local EmbossedFrame = require(Client.Interface.EmbossedFrame)
local ButtonFrame = require(Client.Interface.ButtonFrame)

local ClaimBanner = require(Client.Level.ClaimBanner)

type Scope<T> = Fusion.Scope<typeof(Fusion) & T>
type UsedAs<T> = Fusion.UsedAs<T>

type Components = {
    Icon: typeof(Icon),
    Text: typeof(Text),
    EmbossedFrame: typeof(EmbossedFrame),
    ButtonFrame: typeof(ButtonFrame),

    ClaimBanner: typeof(ClaimBanner),
}

type LevelRewardCardProps = {
    Size: UsedAs<UDim2>,
    Position: UsedAs<UDim2>?,
    AnchorPoint: UsedAs<Vector2>?,

    LayoutOrder: UsedAs<number>?,

    Color: UsedAs<Color3>,

    RewardIcon: UsedAs<string>,
    StatusIcon: UsedAs<string?>,

    LevelText: UsedAs<string>,
    RewardText: UsedAs<string>,

    ClaimColor: UsedAs<Color3>,

    OnClaim: UsedAs<(() -> ())?>,
}

local function LevelRewardCard<U>(scope: Scope<U>, props: LevelRewardCardProps)
    local scope: Scope<Components> = scope:innerScope {
        Icon = Icon,
        Text = Text,
        EmbossedFrame = EmbossedFrame,
        ButtonFrame = ButtonFrame,

        ClaimBanner = ClaimBanner,
    }

    local hasStatus = scope:Computed(function(use)
        return use(props.StatusIcon) ~= nil
    end)

    return scope:New "Frame" {
        Size = props.Size,
        Position = props.Position,
        AnchorPoint = props.AnchorPoint,

        LayoutOrder = props.LayoutOrder,

        BackgroundTransparency = 1,

        [Children] = {
            scope:New "UIListLayout" {
                FillDirection = Enum.FillDirection.Vertical,
                SortOrder = Enum.SortOrder.LayoutOrder,

                HorizontalAlignment = Enum.HorizontalAlignment.Left,
                VerticalAlignment = Enum.VerticalAlignment.Top,

                HorizontalFlex = Enum.UIFlexAlignment.Fill,
                VerticalFlex = Enum.UIFlexAlignment.Fill,

                Padding = UDim.new(0.065, 0),
            },
            
            scope:EmbossedFrame {
                Color = props.Color,
                Size = UDim2.fromScale(1, 1),
                AnchorPoint = Vector2.new(0.5, 0.5),

                CornerRadius = UDim.new(0, 22),

                StrokeColor = Color3.fromRGB(0, 0, 0),
                StrokeThickness = 3.5,

                Children = {
                    scope:New "UIAspectRatioConstraint" {
                        AspectRatio = 1,
                    },

                    scope:Icon {
                        Size = UDim2.fromScale(0.68, 0.68),
                        Position = UDim2.fromScale(0.5, 0.45),
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Icon = props.RewardIcon,
                        IconScale = 1.0,
                    },

                    scope:Computed(function(use, scope: Scope<Components>): Fusion.Child
                        if not use(hasStatus) then
                            return {}
                        end

                        return scope:Icon {
                            Size = UDim2.fromScale(0.35, 0.35),
                            Position = UDim2.fromScale(0.75, 0.25),
                            AnchorPoint = Vector2.new(0.5, 0.5),
                            Icon = use(props.StatusIcon),
                            IconScale = 1.0,
                        }
                    end),

                    scope:Computed(function(use, scope: Scope<Components>): Fusion.Child
                        local onClaim = use(props.OnClaim)

                        if not onClaim then
                            return {}
                        end

                        return scope:ClaimBanner {
                            Size = UDim2.fromScale(1, 0.3),
                            Position = UDim2.fromScale(0.5, 0.5),
                            AnchorPoint = Vector2.new(0.5, 0.5),

                            Color = props.ClaimColor,

                            OnClick = onClaim,
                        }
                    end),

                    scope:Text {
                        Size = UDim2.fromScale(1, 0.2),
                        Position = UDim2.fromScale(0.5, 1),
                        AnchorPoint = Vector2.new(0.5, 1),

                        Text = props.RewardText,
                        TextSize = 14,

                        StrokeSize = 2.0,
                    }
                } :: {Fusion.Child}
            },

            scope:EmbossedFrame {
                Color = props.Color,

                CornerRadius = UDim.new(0, 12),

                StrokeColor = Color3.fromRGB(0, 0, 0),
                StrokeThickness = 3.5,

                Children = scope:Text {
                    Size = UDim2.fromScale(1, 1),
                    BackgroundTransparency = 1,

                    Text = props.LevelText,
                    TextSize = 24,
                    StrokeSize = 2.0,
                },
            },
        },
    }
end

return LevelRewardCard