local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages

local Fusion = require(Packages.Fusion)
local Out = Fusion.Out

type Scope<T> = Fusion.Scope<typeof(Fusion) & T>

local EXPECTED_SCREEN_SIZE = Vector2.new(1920, 1080) * 0.75

local function GlobalScale<U>(scope: Scope<U>): Fusion.UsedAs<number>
    local viewportSize: Fusion.Value<Vector2> = scope:Value(Vector2.zero)

    scope:Hydrate(workspace.CurrentCamera) {
        [Out "ViewportSize"] = viewportSize,
    }

    return scope:Computed(function(use)
        local currentSize = use(viewportSize)
        local scaleX = currentSize.X / EXPECTED_SCREEN_SIZE.X
        local scaleY = currentSize.Y / EXPECTED_SCREEN_SIZE.Y

        return math.min(scaleX, scaleY)
    end)
end

return GlobalScale