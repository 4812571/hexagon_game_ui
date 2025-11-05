--!strict
--!native
--!nolint LocalShadow

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)

local Icon = require(Client.Interface.Icon)
local Text = require(Client.Interface.Text)

type Scope<T> = Fusion.Scope<typeof(Fusion) & T>

export type Components = {
    Icon: typeof(Icon),
    Text: typeof(Text),
}

export type SpinnerIconsProps = {
    Size: Fusion.UsedAs<UDim2>?,
    Position: Fusion.UsedAs<UDim2>?,
    AnchorPoint: Fusion.UsedAs<Vector2>?,

    Icon: Fusion.UsedAs<string>,
    IconScale: Fusion.UsedAs<number>?,

    Text: Fusion.UsedAs<string>,
}

local function SpinnerIcon<U>(scope: Scope<U>, props: SpinnerIconsProps)
    local scope: Scope<Components> = scope:innerScope {
        Icon = Icon,
        Text = Text,
    }

    return scope:Icon {
        Size = props.Size,
        Position = props.Position,
        AnchorPoint = props.AnchorPoint,

        Icon = props.Icon,
        IconScale = props.IconScale,

        Children = scope:Text {
            Size = UDim2.fromScale(1, 0.2),
            Position = UDim2.fromScale(0.5, 0.925),
            TextSize = 28,
            Text = props.Text,
            StrokeSize = 3.0,
        }
    }
end

return SpinnerIcon