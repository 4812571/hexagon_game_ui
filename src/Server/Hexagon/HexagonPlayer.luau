--!strict
--!native

local ServerScriptService = game:GetService("ServerScriptService")

local Server = ServerScriptService.Server

local ServerPlayer = require(Server.Player.ServerPlayer)
type ServerPlayer = ServerPlayer.ServerPlayer

export type HexagonPlayer = {
    Player: ServerPlayer,
    Character: Model,
    Color: Color3,
}

local function HexagonPlayer(player: ServerPlayer, character: Model, color: Color3): HexagonPlayer
    local self: HexagonPlayer = {
        Player = player,
        Character = character,
        Color = color,
    }

    return self
end

return HexagonPlayer
