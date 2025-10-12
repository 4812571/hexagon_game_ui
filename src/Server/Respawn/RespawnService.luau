--!strict
--!native

local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Server = ServerScriptService.Server

local Observe = require(Packages.Observe)
local Fusion = require(Packages.Fusion)
type Scope = Fusion.Scope<typeof(Fusion)>

local NetworkServer = require(ServerScriptService.NetworkServer)

local PlayerService = require(Server.Player.PlayerService)
local HexagonService = require(Server.Hexagon.HexagonService)

export type Services = {
    PlayerService: PlayerService.PlayerService,
    HexagonService: HexagonService.HexagonService,
}

export type RespawnService = {
    Start: () -> (),
}

local function RespawnService(scope: Scope, services: Services): RespawnService
    local PlayerService = services.PlayerService
    local HexagonService = services.HexagonService

    local function Respawn(player: Player)
        player:LoadCharacter()

        local character = player.Character

        if not character then
            error("Character is nil after spawn")
        end

        character:PivotTo(workspace.Lobby.Spawn:GetPivot())
    end

    local function Start()
        table.insert(scope, PlayerService.ObservePlayers(function(serverPlayer: PlayerService.ServerPlayer)
            return Observe.Character(serverPlayer.Player, function(character: Model)
                if not character then
                    return
                end

                local humanoid = character:FindFirstChildOfClass("Humanoid")

                if not humanoid then
                    error("[RespawnService] Player has no humanoid")
                end

                local function OnDeath()
                    local hexPlayer = HexagonService.GetPlayer(serverPlayer)

                    if hexPlayer then
                        HexagonService.RemovePlayer(hexPlayer)
                    else
                        task.delay(2, function() 
                            Respawn(serverPlayer.Player)
                        end)
                    end
                end

                local connection = humanoid.Died:Connect(OnDeath)

                return function()
                    connection:Disconnect()
                end
            end)
        end))

        NetworkServer.Respawn.Respawn.On(Respawn)
    end

    local self: RespawnService = {
        Start = Start,
    }

    return self
end

return RespawnService
