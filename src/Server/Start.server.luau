--!strict

local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Server = ServerScriptService.Server

local Fusion = require(Packages.Fusion)

local JoinService = require(Server.JoinService)
local PlayerService = require(Server.Player.PlayerService)

local HexagonService = require(Server.Hexagon.HexagonService)
local BombService = require(Server.Bombs.BombService)
local DailyRewardsService = require(Server.DailyRewards.DailyRewardsService)
local LevelRewardsService = require(Server.Level.LevelRewardsService)
local TimedRewardsService = require(Server.TimedRewards.TimedRewardsService)
local SkinService = require(Server.Skins.SkinService)

local scope = Fusion.scoped(Fusion)

local playerService = PlayerService(scope)

local hexagonService = HexagonService(scope, {
    PlayerService = playerService,
})

local dailyRewardsService = DailyRewardsService(scope, {
    PlayerService = playerService,
})

local levelRewardsService = LevelRewardsService(scope, {
    PlayerService = playerService,
})

local timedRewardsService = TimedRewardsService(scope, {
    PlayerService = playerService,
})

local bombService = BombService(scope, {
    PlayerService = playerService,
    HexagonService = hexagonService,
})

local playerLoadingService = JoinService(scope, {
    PlayerService = playerService,
    HexagonService = hexagonService,
})

local skinService = SkinService(scope, {
    PlayerService = playerService,
})

local services = {
    PlayerService = playerService,
    HexagonService = hexagonService,
    DailyRewardsService = dailyRewardsService,
    LevelRewardsService = levelRewardsService,
    TimedRewardsService = timedRewardsService,
    BombService = bombService,
    JoinService = playerLoadingService,
    SkinService = skinService,
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