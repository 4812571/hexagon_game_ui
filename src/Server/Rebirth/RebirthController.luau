local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Server = ServerScriptService.Server

local Fusion = require(Packages.Fusion)
type Scope = Fusion.Scope<typeof(Fusion)>

local Terminate = require(Common.Player.Terminate)

local CanRebirth = require(Common.Rebirth.CanRebirth)
local ApplyRebirth = require(Common.Rebirth.ApplyRebirth)

local NetworkServer = require(ServerScriptService.NetworkServer)

local PlayerService = require(Server.Player.PlayerService)

export type Services = {
    PlayerService: PlayerService.PlayerService,
}

export type RebirthController = {
    Start: () -> (),
}

local function RebirthController(scope: Scope, services: Services): RebirthController
    local PlayerService = services.PlayerService

    local function OnRebirth(player: Player): ()
        local serverPlayer = PlayerService.Expect(player)

        if not CanRebirth(serverPlayer) then
            return Terminate(player, "[RebirthController] Player cannot rebirth")
        end

        ApplyRebirth(serverPlayer)

        return
    end

    local function Start()
        NetworkServer.Rebirth.Rebirth.On(OnRebirth)
    end

    local self: RebirthController = {
        Start = Start,
    }

    return self
end

return RebirthController