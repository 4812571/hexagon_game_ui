local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
type Scope = Fusion.Scope<unknown>

export type ServerPlayer = {
    Scope: Scope,
    Player: Player,
    JoinTime: number,
}

local function ServerPlayer(scope: Scope, player: Player, joinTime: number, data: any): ServerPlayer
    local self: ServerPlayer = {
        Scope = scope,
        Player = player,
        JoinTime = joinTime,
    }

    return self
end

return ServerPlayer