--!strict
--!native

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common

local Fusion = require(Packages.Fusion)
type Scope = Fusion.Scope<typeof(Fusion)>

local Connect = require(Common.Connect)

local CharacterDetector = require(Common.CharacterDetector)

local NetworkClient = require(ReplicatedStorage.NetworkClient)

export type LobbyController = {
    Start: () -> (),
}

local function LobbyController(scope: Scope): LobbyController
    local playDetector = CharacterDetector(scope, workspace.Lobby.PlayDetector)
    local spinDetector = CharacterDetector(scope, workspace.Lobby.SpinDetector)

    local function Start()
        Connect(scope, playDetector.Entered, function(player: Player)
            NetworkClient.Hexagon.JoinGame.Invoke()
        end)

        Connect(scope, spinDetector.Entered, function(player: Player)
            print("Spinner!")
        end)

        print("LobbyController started")
    end

    local self: LobbyController = {
        Start = Start,
    }

    return self
end

return LobbyController
