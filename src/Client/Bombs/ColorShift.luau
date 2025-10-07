local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages

local Fusion = require(Packages.Fusion)
type Scope = Fusion.Scope<typeof(Fusion)>
type UsedAs<T> = Fusion.UsedAs<T>

local function ColorShift(scope: Scope, part: BasePart, shiftTo: Color3, alpha: UsedAs<Color3>)
    local initialColor = part.Color
    
    local color = scope:Computed(function(use)
        return initialColor:Lerp(shiftTo, use(alpha))
    end)

    scope:Hydrate(part) {
        Color = color
    }

    table.insert(scope, function()
        part.Color = initialColor
    end)
end

return ColorShift