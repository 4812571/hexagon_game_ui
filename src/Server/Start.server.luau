--!strict

local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Server = ServerScriptService.Server

local Fusion = require(Packages.Fusion)

local JoinService = require(Server.JoinService)
local PlayerService = require(Server.Player.PlayerService)
local HexagonService = require(Server.Hexagon.HexagonService)
local AuthoritativeTimingService = require(Server.AuthoritativeTimingService)

local scope = Fusion.scoped(Fusion)

local playerService = PlayerService(scope)
local authoritativeTimingService = AuthoritativeTimingService(scope)

local hexagonService = HexagonService(scope, {
    PlayerService = playerService,
})

local playerLoadingService = JoinService(scope, {
    PlayerService = playerService,
    HexagonService = hexagonService,
})

local services = {
    PlayerService = playerService,
    AuthoritativeTimingService = authoritativeTimingService,
    PlayerLoadingService = playerLoadingService,
    HexagonService = hexagonService,
}

for _, service: any in services do
    if typeof(service.Init) == "function" then
        service.Init()
    end
end

for _, service: any in services do
    if typeof(service.Start) == "function" then
        service.Start()
    end
end