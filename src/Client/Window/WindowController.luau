local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages

local Fusion = require(Packages.Fusion)
local peek = Fusion.peek
type UsedAs<T> = Fusion.UsedAs<T>
type Scope = Fusion.Scope<typeof(Fusion)>

type WindowType = 
    | "Level"
    | "Quests"
    | "Rebirth"
    | "Trails"

export type WindowController = {
    CloseWindow: () -> (),
    OpenWindow: (windowType: WindowType) -> (),
    ToggleWindow: (windowType: WindowType) -> (),

    CurrentWindow: UsedAs<WindowType?>,
}

local function WindowController(scope: Scope): WindowController
    local currentWindow: Fusion.Value<WindowType?> = scope:Value(nil)

    local function CloseWindow()
        currentWindow:set(nil)
    end

    local function OpenWindow(windowType: WindowType)
        currentWindow:set(windowType)
    end

    local function ToggleWindow(windowType: WindowType)
        if peek(currentWindow) == windowType then
            CloseWindow()
        else
            OpenWindow(windowType)
        end
    end

    local self: WindowController = {
        OpenWindow = OpenWindow,
        CloseWindow = CloseWindow,
        ToggleWindow = ToggleWindow,

        CurrentWindow = currentWindow,
    }

    return self
end

return WindowController