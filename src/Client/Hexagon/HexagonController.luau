local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)
type Scope = Fusion.Scope<typeof(Fusion)>

local NetworkClient = require(ReplicatedStorage.NetworkClient)

local ClientPlayer = require(Client.Player.ClientPlayer)
type ClientPlayer = ClientPlayer.ClientPlayer

export type HexagonController = {
    Start: () -> (),
}

local function HexagonController(scope: Scope, player: ClientPlayer): HexagonController
    local function Start()
        NetworkClient.Hexagon.IsInGameChanged.On(function(isInGame: boolean)
            player.Hexagons.IsInGame:set(isInGame)
        end)
    end

    local self: HexagonController = {
        Start = Start,
    }

    return self
end

return HexagonController