local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)
type Scope = Fusion.Scope<typeof(Fusion)>

local NetworkClient = require(ReplicatedStorage.NetworkClient)

local ClientPlayer = require(Client.Player.ClientPlayer)
type ClientPlayer = ClientPlayer.ClientPlayer

export type RespawnController = {
    Start: () -> (),
}

local function RespawnController(scope: Scope, clientPlayer: ClientPlayer): RespawnController
    local function OnGameOver()
        task.delay(3, NetworkClient.Respawn.Respawn.Invoke)
    end
    
    local function Start()
        NetworkClient.Respawn.GameOver.On(OnGameOver)
        NetworkClient.Respawn.Respawn.Invoke()
    end

    local self = {
        Start = Start,
    }

    return self
end

return RespawnController