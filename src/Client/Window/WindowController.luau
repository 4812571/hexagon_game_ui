local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages

local Fusion = require(Packages.Fusion)
type UsedAs<T> = Fusion.UsedAs<T>
type Scope = Fusion.Scope<typeof(Fusion)>

type WindowType = 
    | "Level"
    | "Quests"
    | "Rebirth"

export type WindowController = {
    OpenWindow: (windowType: WindowType) -> (),
    CloseWindow: () -> (),

    CurrentWindow: UsedAs<(windowType: WindowType) -> ()>,
}

local function WindowController(scope: Scope): WindowController
    local currentWindow: Fusion.Value<WindowType?> = scope:Value(nil)

    local function OpenWindow(windowType: WindowType)
        currentWindow:set(windowType)
    end

    local function CloseWindow()
        currentWindow:set(nil)
    end

    local self: WindowController = {
        OpenWindow = OpenWindow,
        CloseWindow = CloseWindow,

        CurrentWindow = currentWindow,
    }

    return self
end

return WindowController