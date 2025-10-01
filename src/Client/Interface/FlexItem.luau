local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages

local Fusion = require(Packages.Fusion)

export type FlexItemProps = {
    Scope: Fusion.Scope<typeof(Fusion)>,

    FlexMode: Fusion.UsedAs<Enum.UIFlexMode>,
    ItemLineAlignment: Fusion.UsedAs<Enum.ItemLineAlignment>?,
}

local function FlexItem(props: FlexItemProps)
    local scope = props.Scope

    return scope:New "UIFlexItem" {
        FlexMode = props.FlexMode,
        ItemLineAlignment = props.ItemLineAlignment or Enum.ItemLineAlignment.Automatic,
    }
end

return FlexItem