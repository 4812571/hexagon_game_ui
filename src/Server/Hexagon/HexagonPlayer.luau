--!strict
--!native

local ServerScriptService = game:GetService("ServerScriptService")

local Server = ServerScriptService.Server

local ServerPlayer = require(Server.Player.ServerPlayer)
type ServerPlayer = ServerPlayer.ServerPlayer

export type HexagonPlayer = {
    Player: ServerPlayer,
    Character: Model,
    RenderId: number,
}

local function HexagonPlayer(player: ServerPlayer, character: Model, renderId: number): HexagonPlayer
    local self: HexagonPlayer = {
        Player = player,
        Character = character,
        RenderId = renderId,
    }

    return self
end

return HexagonPlayer
