local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages

local Fusion = require(Packages.Fusion)

local Children = Fusion.Children

export type TextLabelProps = {
    Scope: Fusion.Scope<typeof(Fusion)>,

    Name: Fusion.UsedAs<string>?,

    LayoutOrder: Fusion.UsedAs<number>?,

    BackgroundColor3: Fusion.UsedAs<Color3>?,
    BackgroundTransparency: Fusion.UsedAs<number>?,

    AnchorPoint: Fusion.UsedAs<Vector2>?,
    Position: Fusion.UsedAs<UDim2>?,
    Size: Fusion.UsedAs<UDim2>?,

    AutomaticSize: Fusion.UsedAs<Enum.AutomaticSize>?,

    Text: Fusion.UsedAs<string>,

    TextColor3: Fusion.UsedAs<Color3>?,

    TextSize: Fusion.UsedAs<number>?,
    TextWrapped: Fusion.UsedAs<boolean>?,

    TextXAlignment: Fusion.UsedAs<Enum.TextXAlignment>?,
    TextYAlignment: Fusion.UsedAs<Enum.TextYAlignment>?,

    RichText: Fusion.UsedAs<boolean>?,

    StrokeThickness: Fusion.UsedAs<number>?,
    StrokeColor: Fusion.UsedAs<Color3>?,
    StrokeTransparency: Fusion.UsedAs<number>?,

    Children: Fusion.UsedAs<Fusion.Child>?,
}

local function TextLabel(props: TextLabelProps)
    local scope = props.Scope

    return scope:New "TextLabel" {
        Name = props.Name or "TextLabel",

        LayoutOrder = props.LayoutOrder,

        BackgroundColor3 = props.BackgroundColor3 or Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = props.BackgroundTransparency or 1,

        AnchorPoint = props.AnchorPoint or Vector2.new(0, 0),
        Position = props.Position or UDim2.fromScale(0, 0),
        Size = props.Size or UDim2.fromScale(0, 0),

        AutomaticSize = props.AutomaticSize,

        Text = props.Text,

        FontFace = Font.fromEnum(Enum.Font.FredokaOne),

        TextColor3 = props.TextColor3 or Color3.fromRGB(255, 255, 255),

        TextSize = props.TextSize,
        TextWrapped = props.TextWrapped,
        TextScaled = not props.TextSize,

        TextXAlignment = props.TextXAlignment or Enum.TextXAlignment.Left,
        TextYAlignment = props.TextYAlignment or Enum.TextYAlignment.Top,

        RichText = props.RichText,

        [Children] = {
            scope:New "UIStroke" {
                Thickness = props.StrokeThickness or 4,
                Color = props.StrokeColor or Color3.fromRGB(0, 0, 0),
                Transparency = props.StrokeTransparency or 0,

                LineJoinMode = Enum.LineJoinMode.Miter,
            },

            Children = props.Children
        },
    }
end

return TextLabel