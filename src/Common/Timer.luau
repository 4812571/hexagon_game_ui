local RunService = game:GetService("RunService")

local function UpdateSignal(): RBXScriptSignal
    if RunService:IsClient() then
        return RunService.RenderStepped
    end

    if RunService:IsServer() then
        return RunService.Heartbeat
    end

    error("Invalid time context")
end

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