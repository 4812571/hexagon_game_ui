--!strict
--!native

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)

local NetworkClient = require(ReplicatedStorage.NetworkClient)

local ClientPlayer = require(Client.Player.ClientPlayer)

local BinderController = require(Client.BinderController)
local HexagonRenderingController = require(Client.Hexagon.HexagonRenderingController)
local HexagonEffectsController = require(Client.Hexagon.HexagonEffectsController)
local VictoryController = require(Client.Victory.VictoryController)
local BombController = require(Client.Bombs.BombController)
local CrownController = require(Client.Crown.CrownController)
local PlayerSpeedController = require(Client.Player.PlayerSpeedController)
local SpinController = require(Client.Spins.SpinController)
local LevelRewardsController = require(Client.Level.LevelRewardsController)
local DailyRewardsController = require(Client.DailyRewards.DailyRewardsController)
local TimedRewardsController = require(Client.TimedRewards.TimedRewardsController)
local TrailsController = require(Client.Trails.TrailsController)
local MusicController = require(Client.Music.MusicController)
local LobbyController = require(Client.Lobby.LobbyController)
local RespawnController = require(Client.Respawn.RespawnController)

local initialData = NetworkClient.Join.Invoke()

if not initialData then
    return error("[Client] Failed to join the game!")
end

local scope = Fusion.scoped(Fusion)

local clientPlayer = ClientPlayer(scope, Players.LocalPlayer, initialData.JoinTime, initialData.Player)

local binderController = BinderController(scope)
local hexagonRenderingController = HexagonRenderingController(scope, initialData.Hexagon)
local hexagonEffectsController = HexagonEffectsController(scope)
local victoryController = VictoryController(scope)
local crownController = CrownController(scope)
local bombController = BombController(scope, clientPlayer)
local playerSpeedController = PlayerSpeedController(scope, clientPlayer)
local spinController = SpinController(scope, clientPlayer)
local levelRewardsController = LevelRewardsController(scope, clientPlayer)
local dailyRewardsController = DailyRewardsController(scope, clientPlayer)
local timedRewardsController = TimedRewardsController(scope, clientPlayer)
local trailsController = TrailsController(scope, clientPlayer)
local musicController = MusicController(scope, clientPlayer)
local lobbyController = LobbyController(scope)
local respawnController = RespawnController(scope, clientPlayer)

local controllers = {
    BinderController = binderController,
    HexagonRenderingController = hexagonRenderingController,
    VictoryController = victoryController,
    SpinController = spinController,
    BombController = bombController,
    HexagonEffectsController = hexagonEffectsController,
    CrownController = crownController,
    PlayerSpeedController = playerSpeedController,
    LevelRewardsController = levelRewardsController,
    DailyRewardsController = dailyRewardsController,
    TimedRewardsController = timedRewardsController,
    TrailsController = trailsController,
    MusicController = musicController,
    LobbyController = lobbyController,
    RespawnController = respawnController,
}

for _, controller: any in controllers do
    if typeof(controller.Init) == "function" then
        controller.Init()
    end
end

for _, controller: any in controllers do
    if typeof(controller.Start) == "function" then
        controller.Start()
    end
end
