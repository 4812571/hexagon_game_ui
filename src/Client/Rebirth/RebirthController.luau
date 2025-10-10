local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)
type Scope = Fusion.Scope<typeof(Fusion)>

local CanRebirth = require(Common.Rebirth.CanRebirth)
local ApplyRebirth = require(Common.Rebirth.ApplyRebirth)

local NetworkClient = require(ReplicatedStorage.NetworkClient)

local ClientPlayer = require(Client.Player.ClientPlayer)
type ClientPlayer = ClientPlayer.ClientPlayer

export type RebirthController = {
    TryRebirth: () -> boolean,
}

local function RebirthController(scope: Scope, player: ClientPlayer): RebirthController
    local function TryRebirth(): boolean
        if not CanRebirth(player) then
            return false
        end

        ApplyRebirth(player)
        NetworkClient.Rebirth.Rebirth.Invoke()
        return true
    end

    local self: RebirthController = {
        TryRebirth = TryRebirth,
    }

    return self
end

return RebirthController