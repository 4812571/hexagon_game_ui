local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
export type Scope = Fusion.Scope<unknown>

export type ClientPlayer = {
    JoinTime: number,
}

local function ClientPlayer(scope: Scope, joinTime: number): ClientPlayer
    local self: ClientPlayer = {
        JoinTime = joinTime,
    }

    return self
end

return ClientPlayer