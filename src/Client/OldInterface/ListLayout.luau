local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages

local Fusion = require(Packages.Fusion)

export type ListLayoutProps = {
    Scope: Fusion.Scope<typeof(Fusion)>,

    Padding: Fusion.UsedAs<UDim>?,

    FillDirection: Fusion.UsedAs<Enum.FillDirection>,

    HorizontalFlex: Fusion.UsedAs<Enum.UIFlexAlignment>?,
    VerticalFlex: Fusion.UsedAs<Enum.UIFlexAlignment>?,

    HorizontalAlignment: Fusion.UsedAs<Enum.HorizontalAlignment>,
    VerticalAlignment: Fusion.UsedAs<Enum.VerticalAlignment>,
}

local function ListLayout(props: ListLayoutProps)
    local scope = props.Scope

    return scope:New "UIListLayout" {
        SortOrder = Enum.SortOrder.LayoutOrder,

        Padding = props.Padding or UDim.new(0, 0),

        FillDirection = props.FillDirection,

        HorizontalFlex = props.HorizontalFlex or Enum.UIFlexAlignment.None,
        VerticalFlex = props.VerticalFlex or Enum.UIFlexAlignment.None,

        HorizontalAlignment = props.HorizontalAlignment,
        VerticalAlignment = props.VerticalAlignment,
    }
end

return ListLayout