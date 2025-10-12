--!strict
--!native

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage.Common

local UpdateSignal = require(Common.Util.UpdateSignal)

local function Timer(interval: number, callback: () -> ()): () -> ()
    local elapsed = 0

    local connection = UpdateSignal():Connect(function(deltaTime)
        elapsed += deltaTime
    
        while elapsed >= interval do
            elapsed -= interval
            callback()
        end
    end)

    return function()
        connection:Disconnect()
    end
end

return Timer
