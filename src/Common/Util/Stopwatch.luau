local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common

local Fusion = require(Packages.Fusion)
local peek = Fusion.peek

local UpdateSignal = require(Common.Util.UpdateSignal)

type Scope<T> = Fusion.Scope<typeof(Fusion) & T>

local function Stopwatch<U>(scope: Scope<U>): Fusion.UsedAs<number>
    local stopwatch = scope:Value(0)

    table.insert(scope, UpdateSignal():Connect(function(deltaTime: number)
        stopwatch:set(peek(stopwatch) + deltaTime)
    end))

    return stopwatch
end

return Stopwatch