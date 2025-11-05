local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages

local Fusion = require(Packages.Fusion)
local Children = Fusion.Children

type Scope<T> = Fusion.Scope<typeof(Fusion) & T>

export type TextProps = {
    Size: Fusion.UsedAs<UDim2>?,
    Position: Fusion.UsedAs<UDim2>?,
    AnchorPoint: Fusion.UsedAs<Vector2>?,

    Text: Fusion.UsedAs<string>,
    TextSize: Fusion.UsedAs<number>,
    TextColor3: Fusion.UsedAs<Color3>?,

    StrokeSize: Fusion.UsedAs<number>?,
    StrokeColor3: Fusion.UsedAs<Color3>?,

    TextXAlignment: Fusion.UsedAs<Enum.TextXAlignment>?,
    TextYAlignment: Fusion.UsedAs<Enum.TextYAlignment>?,
}

local function Text<U>(scope: Scope<U>, props: TextProps)
    return scope:New "TextLabel" {
        Size = props.Size or UDim2.fromScale(1, 1),
        Position = props.Position or UDim2.fromScale(0.5, 0.5),
        AnchorPoint = props.AnchorPoint or Vector2.new(0.5, 0.5),

        BackgroundTransparency = 1,

        Text = props.Text,
        TextSize = props.TextSize,
        TextColor3 = props.TextColor3 or Color3.new(1, 1, 1),
    
        Font = Enum.Font.FredokaOne,

        TextXAlignment = props.TextXAlignment or Enum.TextXAlignment.Center,
        TextYAlignment = props.TextYAlignment or Enum.TextYAlignment.Center,

        [Children] = scope:New "UIStroke" {
            Thickness = props.StrokeSize or 2.5,
            Color = props.StrokeColor3 or Color3.new(0, 0, 0),
            LineJoinMode = Enum.LineJoinMode.Miter,
        },
    }
end

return Text