local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)

local NetworkClient = require(ReplicatedStorage.NetworkClient)

local ClientPlayer = require(Client.Player.ClientPlayer)

local BinderController = require(Client.BinderController)
local HexagonRenderingController = require(Client.Hexagon.HexagonRenderingController)

local initialData = NetworkClient.Join.Invoke()

local scope = Fusion.scoped(Fusion)

local clientPlayer = ClientPlayer(scope, initialData.JoinTime)
print(`[Client] Joined the game at {clientPlayer.JoinTime}!`)

local binderController = BinderController(scope)
local hexagonRenderingController = HexagonRenderingController(scope, initialData.Hexagon)

local controllers = {
    BinderController = binderController,
    HexagonRenderingController = hexagonRenderingController,
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