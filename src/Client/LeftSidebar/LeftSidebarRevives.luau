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

type Scope<T> = Fusion.Scope<typeof(Fusion) & T>

type Components = {
    Icon: typeof(Icon),
    Text: typeof(Text),
}

type LeftSidebarRevivesProps = {
    Size: Fusion.UsedAs<UDim2>?,
    Position: Fusion.UsedAs<UDim2>?,
    AnchorPoint: Fusion.UsedAs<Vector2>?,

    LayoutOrder: Fusion.UsedAs<number>?,

    Revives: Fusion.UsedAs<number>,
}

local function LeftSidebarRevives<U>(scope: Scope<U>, props: LeftSidebarRevivesProps)
    local scope: Scope<Components> = scope:innerScope {
        Icon = Icon,
        Text = Text,
    }

    return scope:New "Frame" {
        Size = props.Size,
        Position = props.Position,
        AnchorPoint = props.AnchorPoint,

        LayoutOrder = props.LayoutOrder,

        BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.X,

        [Children] = {
            scope:New "UIListLayout" {
                Padding = UDim.new(0, 8),
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Left,
                VerticalAlignment = Enum.VerticalAlignment.Center,
            },

            scope:Icon {
                LayoutOrder = 1,
                Icon = Icons.Heart,
                
                Size = UDim2.fromScale(1, 1),
                Position = UDim2.fromScale(0.0, 0.5),
                AnchorPoint = Vector2.new(0.0, 0.5),
            },

            scope:Text {
                LayoutOrder = 2,
                Size = UDim2.fromScale(1, 1),

                Text = scope:Computed(function(use)
                    return `Revives: x{use(props.Revives)}`
                end),

                TextXAlignment = Enum.TextXAlignment.Left,
                TextSize = 68,
                StrokeSize = 2.0,
            },
        }
    }
end

return LeftSidebarRevives