local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages

local Fusion = require(Packages.Fusion)
type Scope = Fusion.Scope<typeof(Fusion)>
type Value<T> = Fusion.Value<T>

local Observe = require(Packages.Observe)

export type HexagonTile = {
    Instance: Instance,
}

local function HexagonTile(scope: Scope, instance: Instance): HexagonTile
    local hexagon = instance:FindFirstChild("Hexagon") :: BasePart
    local selector = instance:FindFirstChild("Selector") :: BasePart

    table.insert(scope, Observe.Attribute(instance, "TileColor", function(color: Color3)
        hexagon.Color = color
    end))

    table.insert(scope, Observe.Attribute(instance, "IsOwned", function(isOwned: boolean)
        hexagon.Transparency = if isOwned then 0 else 1
    end))

    table.insert(scope, Observe.Attribute(instance, "SelectionColor", function(color: Color3)
        selector.Color = color
    end))

    table.insert(scope, Observe.Attribute(instance, "IsSelected", function(isSelected: boolean)
        selector.Transparency = if isSelected then 0 else 1
    end))

    local self = {
        Instance = instance,
    }

    return self
end

return HexagonTile