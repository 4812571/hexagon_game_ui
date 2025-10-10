local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages

local Fusion = require(Packages.Fusion)
type Scope = Fusion.Scope<typeof(Fusion)>

local NetworkClient = require(ReplicatedStorage.NetworkClient)

export type VictoryController = {
    Start: () -> (),
}

local function VictoryController(scope: Scope)
    local function OnWinnerSeconds(winner: Player?, seconds: number)
        if winner then
            if seconds <= 0 then
                print(`[VictoryController] {winner.Name} has won the game!`)
            else
                print(`[VictoryController] {winner.Name} will win in {seconds} seconds!`)
            end
        else
            print("[VictoryController] No winner candidate")
        end
    end

    local function Start()
        NetworkClient.Hexagon.WinnerSeconds.On(OnWinnerSeconds)
    end

    local self = {
        Start = Start,
    }

    return self
end

return VictoryController