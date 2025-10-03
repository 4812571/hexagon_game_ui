local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages

local Fusion = require(Packages.Fusion)

local Children = Fusion.Children

export type FrameProps = {
    Scope: Fusion.Scope<typeof(Fusion)>,

    Name: Fusion.UsedAs<string>?,

    LayoutOrder: Fusion.UsedAs<number>?,

    AnchorPoint: Fusion.UsedAs<Vector2>?,
    Position: Fusion.UsedAs<UDim2>?,
    Size: Fusion.UsedAs<UDim2>?,
    Rotation: Fusion.UsedAs<number>?,

    SizeConstraint: Fusion.UsedAs<Enum.SizeConstraint>?,

    BackgroundColor3: Fusion.UsedAs<Color3>?,
    BackgroundTransparency: Fusion.UsedAs<number>?,

    AutomaticSize: Fusion.UsedAs<Enum.AutomaticSize>?,

    Scale: Fusion.UsedAs<number>?,

    Children: Fusion.UsedAs<Fusion.Child>?,
}

local function Frame(props: FrameProps)
    local scope = props.Scope

    return scope:New "Frame" {
        Name = props.Name or "Frame",

        LayoutOrder = props.LayoutOrder,

        AnchorPoint = props.AnchorPoint or Vector2.new(0, 0),
        Position = props.Position or UDim2.fromScale(0, 0),
        Size = props.Size or UDim2.fromScale(0, 0),
        Rotation = props.Rotation,

        SizeConstraint = props.SizeConstraint,

        BackgroundColor3 = props.BackgroundColor3 or Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = props.BackgroundTransparency or 0,

        AutomaticSize = props.AutomaticSize,

        [Children] = {
            Scale = if props.Scale then scope:New "UIScale" {
                Scale = props.Scale
            } else nil,
            Children = props.Children
        }
    }
end

return Frame