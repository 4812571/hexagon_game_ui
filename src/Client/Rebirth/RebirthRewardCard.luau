--!strict
--!native
--!nolint LocalShadow

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)

local Icon = require(Client.Interface.Icon)
local Text = require(Client.Interface.Text)
local EmbossedFrame = require(Client.Interface.EmbossedFrame)

type Scope<T> = Fusion.Scope<typeof(Fusion) & T>

type Components = {
    Icon: typeof(Icon),
    Text: typeof(Text),
    EmbossedFrame: typeof(EmbossedFrame),
}

type RebirthRewardCardProps = {
    Size: Fusion.UsedAs<UDim2>?,
    Position: Fusion.UsedAs<UDim2>?,
    AnchorPoint: Fusion.UsedAs<Vector2>?,

    LayoutOrder: Fusion.UsedAs<number>?,

    Color: Fusion.UsedAs<Color3>,
    Icon: Fusion.UsedAs<string>,
    TopText: Fusion.UsedAs<string>,
    BottomText: Fusion.UsedAs<string>,
}

local function RebirthRewardCard<U>(scope: Scope<U>, props: RebirthRewardCardProps)
    local scope: Scope<Components> = scope:innerScope {
        Icon = Icon,
        Text = Text,
        EmbossedFrame = EmbossedFrame,
    }

    return scope:EmbossedFrame {
        Size = props.Size,
        Position = props.Position,
        AnchorPoint = props.AnchorPoint,

        LayoutOrder = props.LayoutOrder,
        
        CornerRadius = UDim.new(0, 12),
        StrokeThickness = 4,
        Color = props.Color,

        Children = {
            scope:Icon {
                Icon = props.Icon,
                Size = UDim2.fromScale(0.8, 0.8),
                Position = UDim2.fromScale(0.5, 0.5),
                AnchorPoint = Vector2.new(0.5, 0.5),
            },

            scope:Text {
                Size = UDim2.fromScale(1, 0),
                Position = UDim2.fromScale(0.5, 0),

                AutomaticSize = Enum.AutomaticSize.Y,
                TextSize = 32,

                Text = props.TopText,
                StrokeSize = 3.5,
            },

            scope:Text {
                Size = UDim2.fromScale(1, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                TextSize = 32,

                Position = UDim2.fromScale(0.5, 1),
                Text = props.BottomText,
                StrokeSize = 3.5,
            },
        },
    }
end

return RebirthRewardCard
