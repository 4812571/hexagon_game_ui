local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)
type Scope = Fusion.Scope<typeof(Fusion)>

local Trails = require(Common.Trails.Trails)

local NetworkClient = require(ReplicatedStorage.NetworkClient)

local ClientPlayer = require(Client.Player.ClientPlayer)
type ClientPlayer = ClientPlayer.ClientPlayer

export type TrailsController = {
    TryPurchase: (trailId: string) -> boolean,
    TryEquip: (trailId: string?) -> boolean,
}

local function TrailsController(scope: Scope, player: ClientPlayer)
    local function TryPurchase(trailId: string): boolean
        if player.Trails.HasTrail(trailId) then
            return false
        end

        local trailEntry: Trails.TrailEntry? = Trails[trailId]

        if not trailEntry then
            warn("[TrailsController] Invalid trail id: " .. trailId)
            return false
        end

        if trailEntry.Price.Currency ~= "Coins" then
            warn("[TrailsController] Cannot purchase non-coin trails directly")
            return false
        end

        if not player.Coins.ConsumeCoins(trailEntry.Price.Amount) then
            return false
        end

        player.Trails.AddTrail(trailId)

        NetworkClient.Trails.PurchaseTrail.Invoke(trailId)

        return true
    end

    local function TryEquip(trailId: string?): boolean
        if trailId and not player.Trails.HasTrail(trailId) then
            return false
        end

        player.Trails.EquippedId:set(trailId)
        NetworkClient.Trails.EquipTrail.Invoke(trailId)
        return true
    end

    local self: TrailsController = {
        TryPurchase = TryPurchase,
        TryEquip = TryEquip,
    }

    return self
end

return TrailsController