--!strict

local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Server = ServerScriptService.Server

local Fusion = require(Packages.Fusion)

local JoinService = require(Server.JoinService)
local PlayerService = require(Server.Player.PlayerService)
local AuthoritativeTimingService = require(Server.AuthoritativeTimingService)

local HexagonService = require(Server.Hexagon.HexagonService)
local BombService = require(Server.Bombs.BombService)
local DailyRewardsService = require(Server.DailyRewards.DailyRewardsService)
local LevelRewardsService = require(Server.Level.LevelRewardsService)
local TimedRewardsService = require(Server.TimedRewards.TimedRewardsService)

local scope = Fusion.scoped(Fusion)

local playerService = PlayerService(scope)
local authoritativeTimingService = AuthoritativeTimingService(scope)

local hexagonService = HexagonService(scope, {
    PlayerService = playerService,
})

local bombService = BombService(scope, {
    AuthoritativeTimingService = authoritativeTimingService,
    PlayerService = playerService,
    HexagonService = hexagonService,
})

local playerLoadingService = JoinService(scope, {
    PlayerService = playerService,
    HexagonService = hexagonService,
})

local dailyRewardsService = DailyRewardsService(scope, {
    AuthoritativeTimingService = authoritativeTimingService,
    PlayerService = playerService,
})

local levelRewardsService = LevelRewardsService(scope, {
    AuthoritativeTimingService = authoritativeTimingService,
    PlayerService = playerService,
})

local timedRewardsService = TimedRewardsService(scope, {
    PlayerService = playerService,
    AuthoritativeTimingService = authoritativeTimingService,
})

local services = {
    PlayerService = playerService,
    AuthoritativeTimingService = authoritativeTimingService,
    
    HexagonService = hexagonService,
    BombService = bombService,

    PlayerLoadingService = playerLoadingService,
    DailyRewardsService = dailyRewardsService,
    LevelRewardsService = levelRewardsService,
    TimedRewardsService = timedRewardsService,
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