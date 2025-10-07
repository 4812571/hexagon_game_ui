--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)

local NetworkClient = require(ReplicatedStorage.NetworkClient)

local ClientPlayer = require(Client.Player.ClientPlayer)

local BinderController = require(Client.BinderController)
local HexagonRenderingController = require(Client.Hexagon.HexagonRenderingController)
local BombController = require(Client.Bombs.BombController)
local CrownController = require(Client.Crown.CrownController)

local initialData = NetworkClient.Join.Invoke()

if not initialData then
    error("[Client] Failed to join the game!")
end

local scope = Fusion.scoped(Fusion)

local clientPlayer = ClientPlayer(scope, initialData.JoinTime, initialData.Player)
print(`[Client] Joined the game at {clientPlayer.JoinTime}!`)

local binderController = BinderController(scope)
local hexagonRenderingController = HexagonRenderingController(scope, initialData.Hexagon)
local crownController = CrownController(scope)
local bombController = BombController(scope, clientPlayer)

local controllers = {
    BinderController = binderController,
    HexagonRenderingController = hexagonRenderingController,
    BombController = bombController,
    CrownController = crownController,
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