local function Terminate(player: Player, message: string, level: number?): never
    player:Kick(message)
    return error(message, if level then level + 1 else 2)
end

return Terminate