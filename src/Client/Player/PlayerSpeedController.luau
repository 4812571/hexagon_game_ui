--!strict
--!native

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)
local peek = Fusion.peek
type Scope = Fusion.Scope<typeof(Fusion)>

type Cleanup = () -> ()

local Observe = require(Packages.Observe)

local ClientPlayer = require(Client.Player.ClientPlayer)
type ClientPlayer = ClientPlayer.ClientPlayer

export type PlayerSpeedController = {
    Start: () -> (),
}

local function PlayerSpeedController(scope: Scope, player: ClientPlayer): PlayerSpeedController
    local localPlayer = Players.LocalPlayer

    local function Start()
        table.insert(scope, Observe.Character(localPlayer, function(character: Model?): Cleanup?
            if not character then
                return nil
            end

            local characterScope = scope:innerScope()

            local function applySpeed()
                local humanoid = character:FindFirstChildOfClass("Humanoid")

                if humanoid then
                    humanoid.WalkSpeed = peek(player.Speed.Speed)
                end
            end

            characterScope:Observer(player.Speed.Speed):onBind(function()
                applySpeed()
            end)

            characterScope:Observer(player.Speed.Speed):onChange(function()
                applySpeed()
            end)

            table.insert(characterScope, character.ChildAdded:Connect(function(child)
                if child:IsA("Humanoid") then
                    applySpeed()
                end
            end))

            return function()
                characterScope:doCleanup()
            end
        end))
    end

    local self: PlayerSpeedController = {
        Start = Start,
    }

    return self
end

return PlayerSpeedController
