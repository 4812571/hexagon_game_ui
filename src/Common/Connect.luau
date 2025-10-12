--!strict
--!native

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages

local Signal = require(Packages.Signal)
type Signal<T...> = Signal.Signal<T...>

local Fusion = require(Packages.Fusion)
type Scope = Fusion.Scope<unknown>


local function Connect<T...>(scope: Scope, event: Signal<T...>, handler: (T...) -> ())
    local connection = event:Connect(handler)

    table.insert(scope, function()
        connection:Disconnect()
    end)
end

return Connect
