--!strict
--!native
--!nolint LocalShadow

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)
local Children = Fusion.Children

local Icon = require(Client.Interface.Icon)

type Scope<T> = Fusion.Scope<typeof(Fusion) & T>

export type Components = {
    Icon: typeof(Icon),
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
    }

    return scope:Icon {
        Size = props.Size,
        Position = props.Position,
        AnchorPoint = props.AnchorPoint,

        Icon = props.Icon,
        IconScale = props.IconScale,

        Children = scope:New "TextLabel" {
            Size = UDim2.fromScale(1, 0.2),
            Position = UDim2.fromScale(0.5, 0.925),
            AnchorPoint = Vector2.new(0.5, 0.5),

            TextXAlignment = Enum.TextXAlignment.Center,
            TextYAlignment = Enum.TextYAlignment.Center,

            Font = Enum.Font.FredokaOne,

            BackgroundTransparency = 1,
            TextColor3 = Color3.new(1, 1, 1),
            TextSize = 28,
            Text = props.Text,

            [Children] = scope:New "UIStroke" {
                Thickness = 3,
                Color = Color3.new(0, 0, 0),
            }
        }
    }
end

return SpinnerIcon