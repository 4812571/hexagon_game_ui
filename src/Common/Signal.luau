local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages

local Fusion = require(Packages.Fusion)
type Scope = Fusion.Scope<unknown>

local Signal = require(Packages.Signal)
export type Signal<T...> = Signal.Signal<T...>

local function NewSignal<T...>(scope: Scope): Signal<T...>
    local signal = Signal.new()

    table.insert(scope, function()
        signal:Destroy()
    end)

    return signal
end

return NewSignal