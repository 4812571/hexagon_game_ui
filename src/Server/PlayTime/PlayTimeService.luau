--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Server = ServerScriptService.Server

local Fusion = require(Packages.Fusion)
type Scope = Fusion.Scope<typeof(Fusion)>

local Signal = require(Common.Signal)
local Timer = require(Common.Util.Timer)

local NetworkServer = require(ServerScriptService.NetworkServer)

local PlayerService = require(Server.Player.PlayerService)
type PlayerService = PlayerService.PlayerService

export type Services = {
    PlayerService: PlayerService,
}

export type PlayTimeService = {
    Start: () -> (),
    MinuteSignal: Signal.Signal<()>,
}

local function PlayTimeService(scope: Scope, services: Services): PlayTimeService
    local PlayerService = services.PlayerService
    
    local minuteSignal = Signal(scope)

    local function Start()
        table.insert(scope, Timer(60, function()
            minuteSignal:Fire()
        end))

        table.insert(scope, minuteSignal:Connect(function()
            PlayerService.FireAll(NetworkServer.PlayTime.MinutePassed)
        end))
    end

    local self: PlayTimeService = {
        Start = Start,
        MinuteSignal = minuteSignal,
    }

    return self
end

return PlayTimeService