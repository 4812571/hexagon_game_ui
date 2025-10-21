--!strict
--!native
--!nolint LocalShadow

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)
local Children = Fusion.Children

local TopbarItem = require(Client.Topbar.TopbarItem)

type Scope<T> = Fusion.Scope<typeof(Fusion) & T>

export type Components = {
    TopbarItem: typeof(TopbarItem),
}

export type ItemProps = {
    Icon: Fusion.UsedAs<string>,
    Text: Fusion.UsedAs<string>,
    BounceScale: Fusion.UsedAs<number>,
    OnPurchase: () -> (),
}

export type TopbarProps = {
    Scale: Fusion.UsedAs<number>,
    Position: Fusion.UsedAs<UDim2>?,
    AnchorPoint: Fusion.UsedAs<Vector2>?,

    LeftBar: ItemProps,
    RightBar: ItemProps,

    Text: Fusion.UsedAs<string?>,
}

local function Topbar<U>(scope: Scope<U>, props: TopbarProps)
    local scope: Scope<Components> = scope:innerScope {
        TopbarItem = TopbarItem,
    }

    return scope:New "Frame" {
        Position = props.Position,
        AnchorPoint = props.AnchorPoint,

        AutomaticSize = Enum.AutomaticSize.XY,
        BackgroundTransparency = 1,

        [Children] = {
            scope:New "UIScale" {
                Scale = props.Scale,
            },

            scope:New "UIListLayout" {
                FillDirection = Enum.FillDirection.Vertical,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                VerticalAlignment = Enum.VerticalAlignment.Top,
                Padding = UDim.new(0, 16),
            },

            scope:New "Frame" {
                AutomaticSize = Enum.AutomaticSize.XY,
                BackgroundTransparency = 1,

                [Children] = {
                    scope:New "UIListLayout" {
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        FillDirection = Enum.FillDirection.Horizontal,
                        HorizontalAlignment = Enum.HorizontalAlignment.Center,
                        VerticalAlignment = Enum.VerticalAlignment.Top,
                        Padding = UDim.new(0, 100),
                    },

                    scope:TopbarItem {
                        Size = UDim2.fromOffset(400, 100),
                        LayoutOrder = 1,

                        Icon = props.LeftBar.Icon,
                        Text = props.LeftBar.Text,
                        BounceScale = props.LeftBar.BounceScale,
                        OnPurchaseButton = props.LeftBar.OnPurchase,
                    },

                    scope:TopbarItem {
                        Size = UDim2.fromOffset(400, 100),
                        LayoutOrder = 2,

                        Icon = props.RightBar.Icon,
                        Text = props.RightBar.Text,
                        BounceScale = props.RightBar.BounceScale,
                        OnPurchaseButton = props.RightBar.OnPurchase,
                    },
                },
            },

            scope:Computed(function(use)
                local text: string? = use(props.Text)

                if not text then
                    return {} :: Fusion.Child
                end

                return scope:New "TextLabel" {
                    Text = text,
                    BackgroundTransparency = 1,

                    TextSize = 56,
                    Font = Enum.Font.FredokaOne,
                    TextColor3 = Color3.new(1, 1, 1),
                    AutomaticSize = Enum.AutomaticSize.XY,
                    TextXAlignment = Enum.TextXAlignment.Center,
                    TextYAlignment = Enum.TextYAlignment.Center,
                    LayoutOrder = 3,

                    [Children] = {
                        scope:New "UIGradient" {
                            Color = ColorSequence.new {
                                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 196, 0)),
                                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 247, 0)),
                                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 196, 0)),
                            },
                            Rotation = 90,
                        },

                        scope:New "UIStroke" {
                            Thickness = 2,
                            Color = Color3.fromRGB(0, 0, 0),
                        }
                    }
                }
            end) :: Fusion.UsedAs<Fusion.Child>,
        } :: {Fusion.Child}
    }
end

return Topbar