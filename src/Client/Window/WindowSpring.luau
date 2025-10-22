local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages

local Fusion = require(Packages.Fusion)

type Scope<T> = Fusion.Scope<typeof(Fusion) & T>

export type WindowType = 
    | "Level"
    | "Quests"
    | "Rebirth"

local function WindowSpring<U>(scope: Scope<U>, windowName: WindowType, currentWindow: Fusion.UsedAs<WindowType?>)
    local controlValue = scope:Computed(function(use)
        return if use(currentWindow) == windowName then 1 else 0
    end)

    local directSpring = scope:Spring(controlValue, 32)

    local isOtherWindow = scope:Computed(function(use)
        return use(currentWindow) ~= nil and use(currentWindow) ~= windowName
    end)

    return scope:Computed(function(use)
        if use(isOtherWindow) then
            return 0
        end

        return use(directSpring)
    end)
end

return WindowSpring