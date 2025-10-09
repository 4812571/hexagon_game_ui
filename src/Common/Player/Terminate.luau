local function Terminate(player: Player, message: string): never
    player:Kick(message)
    return error(message, 2)
end

return Terminate