local Players = game:GetService("Players")

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages

local Fusion = require(Packages.Fusion)
type Scope = Fusion.Scope<typeof(Fusion)>

export type AuthoritativeTimingService = {
    Init: () -> (),
    Register: (player: Player, clientTime: number) -> (boolean),
}

local ALLOWED_LATENCY = 8

local function AuthoritativeTimingService(scope: Scope): AuthoritativeTimingService
    local lastRecordedTimes = {}

    local function Init()
        Players.PlayerRemoving:Connect(function(player)
            lastRecordedTimes[player] = nil
        end)
    end

    local function Register(player: Player, clientTime: number): boolean
        if math.abs(clientTime - workspace:GetServerTimeNow()) > ALLOWED_LATENCY then
            return false
        end

        local lastTime = lastRecordedTimes[player]

        if lastTime and clientTime <= lastTime then
            return false
        end

        lastRecordedTimes[player] = clientTime
        return true
    end

    local self = {
        Init = Init,
        Register = Register,
    }

    return self
end

return AuthoritativeTimingService