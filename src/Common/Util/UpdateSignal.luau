local RunService = game:GetService("RunService")

local function UpdateSignal(): RBXScriptSignal<number>
    if RunService:IsClient() then
        return RunService.RenderStepped
    end

    if RunService:IsServer() then
        return RunService.Heartbeat
    end

    error("Invalid time context")
end

return UpdateSignal