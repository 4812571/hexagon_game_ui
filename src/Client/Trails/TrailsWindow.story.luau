--!strict
--!native

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)
local peek = Fusion.peek

local Trails = require(Common.Trails.Trails)
local TrailShop = require(Common.Trails.TrailsShop)

local TrailsWindow = require(Client.Trails.TrailsWindow)

return function(target: Instance)
    local scope = Fusion.scoped(Fusion, {
        TrailsWindow = TrailsWindow,
    })

    local equippedTrail = scope:Value(nil)
    local ownedTrails = scope:Value({} :: {[string]: boolean})
    local currentEntry = scope:Value(TrailShop[1])

    local scale = scope:Value(1)

    local window = scope:TrailsWindow {
        OnClose = function()
            scale:set(0)
        end,

        Scale = scope:Spring(scale, 35),
        Visible = true,

        Trails = TrailShop,
        SelectedTrail = currentEntry,
        EquippedTrail = equippedTrail,
        OwnedTrails = ownedTrails,

        OnTrailSelected = function(trail: Trails.TrailEntry)
            currentEntry:set(trail)
        end,

        OnPurchase = function(trail: Trails.TrailEntry)
            local trails = peek(ownedTrails)
            trails[trail.Id] = true
            ownedTrails:set(trails)
        end,

        OnEquip = function(trail: Trails.TrailEntry?)
            equippedTrail:set(if trail then trail.Id else nil)
        end,
    }

    window.Parent = target

    return function()
        scope:doCleanup()
    end
end
