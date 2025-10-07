local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common

local Fusion = require(Packages.Fusion)
type Scope = Fusion.Scope<typeof(Fusion)>
type UsedAs<T> = Fusion.UsedAs<T>

local UpdateSignal = require(Common.Util.UpdateSignal)

local function Clock(scope: Scope): UsedAs<number>
    local currentTime = scope:Value(workspace:GetServerTimeNow())

    table.insert(scope, UpdateSignal():Connect(function(deltaTime)
        currentTime:set(workspace:GetServerTimeNow())
    end))

    return currentTime
end

return Clock
