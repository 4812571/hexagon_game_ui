---!strict
--!native
--!nolint LocalShadow

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Client = ReplicatedStorage.Client
local Packages = ReplicatedStorage.Packages

local Fusion = require(Packages.Fusion)

local WindowSpring = require(Client.Window.WindowSpring)
local GlobalScale = require(Client.Interface.GlobalScale)

type Scope<T> = Fusion.Scope<typeof(Fusion) & T>

export type Components = {
    GlobalScale: typeof(GlobalScale),
    WindowSpring: typeof(WindowSpring),
}

export type WindowScaling = {
    Scale: Fusion.UsedAs<number>,
    Visible: Fusion.UsedAs<boolean>,
}

local BASE_SCALE = 0.85

local function WindowScaling<U>(scope: Scope<U>, windowName: WindowSpring.WindowType, activeWindow: Fusion.UsedAs<WindowSpring.WindowType?>): WindowScaling
    local scope: Scope<Components> = scope:innerScope {
    GlobalScale = GlobalScale,
        WindowSpring = WindowSpring,
    }

    local globalScale = scope:GlobalScale()
    local springScale = scope:WindowSpring(windowName, activeWindow)

    local windowScaling: WindowScaling = {
        Visible = scope:Computed(function(use)
            return use(springScale) > 0
        end),

        Scale = scope:Computed(function(use)
            return BASE_SCALE * use(globalScale) * use(springScale)
        end),
    }

    return windowScaling
end

return WindowScaling