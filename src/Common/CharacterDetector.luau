--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common

local Fusion = require(Packages.Fusion)
type Scope = Fusion.Scope<typeof(Fusion)>

local UpdateSignal = require(Common.Util.UpdateSignal)
local Signal = require(Common.Signal)

type Set<T> = { [T]: true }

local TAU = math.pi * 2

local function Difference<T>(a: Set<T>, b: Set<T>): Set<T>
    local result: Set<T> = {}

    for key, _ in a do
        if not b[key] then
            result[key] = true
        end
    end

    return result
end

type CharacterDetector = {
    Entered: Signal.Signal<Player>,
    Exited: Signal.Signal<Player>,
}

local function CharacterDetector(scope: Scope, instance: Instance)
    if not instance:IsA("Model") then
        error("Expected instance to be a Model")
    end

    local detector = instance:FindFirstChild("Detector")

    if not (detector and detector:IsA("BasePart")) then
        error("Expected instance to have a child named 'Detector' of type BasePart")
    end

    local ring = instance:FindFirstChild("Ring")

    if not (ring and ring:IsA("BasePart")) then
        error("Expected instance to have a child named 'Ring' of type BasePart")
    end

    local function SpinRing(deltaTime: number)
        ring.CFrame *= CFrame.Angles(0, TAU * 0.2 * deltaTime, 0)
    end

    local currentPlayers: Set<Player> = {}

    local enteredSignal: Signal.Signal<Player> = Signal(scope)
    local exitedSignal: Signal.Signal<Player> = Signal(scope)

    local function UpdatePlayers()
        local foundPlayers: Set<Player> = {}

        local foundParts = workspace:GetPartBoundsInBox(detector.CFrame, detector.Size)

        for _, part in foundParts do
            local player = game.Players:GetPlayerFromCharacter(part.Parent)

            if player then
                foundPlayers[player] = true
            end
        end

        local entered: Set<Player> = Difference(foundPlayers, currentPlayers)
        local exited: Set<Player> = Difference(currentPlayers, foundPlayers)

        for player, _ in entered do
            enteredSignal:Fire(player)
        end

        for player, _ in exited do
            exitedSignal:Fire(player)
        end

        currentPlayers = foundPlayers
    end

    local function Update(deltaTime: number)
        SpinRing(deltaTime)
        UpdatePlayers()
    end

    table.insert(scope, UpdateSignal():Connect(Update))

    local self: CharacterDetector = {
        Entered = enteredSignal,
        Exited = exitedSignal,
    }

    return self
end

return CharacterDetector