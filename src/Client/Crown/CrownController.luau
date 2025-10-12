--!strict
--!native

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common

local Fusion = require(Packages.Fusion)
type Scope = Fusion.Scope<typeof(Fusion)>

local HexagonData = require(Common.Hexagon.HexagonData)
type InitialData = HexagonData.HexagonData

local NetworkClient = require(ReplicatedStorage.NetworkClient)

export type CrownController = {
    Start: () -> (),
}

local function CrownController(scope: Scope)
    local previouslyCrowned: Instance? = nil

    local function CrownPlayer(player: Player?)
        if previouslyCrowned and previouslyCrowned:IsDescendantOf(workspace) then
            previouslyCrowned:RemoveTag("CharacterCrown")
        end

        if not player then
            return
        end

        local character = player.Character

        if not character then
            return
        end

        character:AddTag("CharacterCrown")
        previouslyCrowned = character
    end

    local function Start()
        NetworkClient.Hexagon.PlayerCrowned.On(CrownPlayer)
    end

    local self = {
        Start = Start
    }

    return self
end

return CrownController
