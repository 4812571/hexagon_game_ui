--!strict
--!native
--!nolint LocalShadow

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)
local peek = Fusion.peek

local Trails = require(Common.Trails.Trails)
local TrailsShop = require(Common.Trails.TrailsShop)

local NetworkClient = require(ReplicatedStorage.NetworkClient)
local Observe = require(ReplicatedStorage.Packages.Observe)

local ClientPlayer = require(Client.Player.ClientPlayer)
type ClientPlayer = ClientPlayer.ClientPlayer

local WindowController = require(Client.Window.WindowController)
local WindowScaling = require(Client.Window.WindowScaling)

local TrailWindow = require(Client.Trails.TrailsWindow)

export type TrailsController = {
    TryPurchase: (trailId: string) -> boolean,
    TryEquip: (trailId: string?) -> boolean,

    Start: () -> (),
}

type Scope<T> = Fusion.Scope<typeof(Fusion) & T>

export type Components = {
    TrailsWindow: typeof(TrailWindow),
    WindowScaling: typeof(WindowScaling),
}

export type Controllers = {
    WindowController: WindowController.WindowController,
}

local function TrailsController<U>(scope: Scope<U>, player: ClientPlayer, controllers: Controllers): TrailsController
    local WindowController = controllers.WindowController

    local scope: Scope<Components> = scope:innerScope {
        TrailsWindow = TrailWindow,
        WindowScaling = WindowScaling,
    }

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

    local selectedTrail = scope:Value(TrailsShop[1])

    local windowScaling = scope:WindowScaling("Trails", WindowController.CurrentWindow)

    local trailsWindow = scope:TrailsWindow {
        Scale = windowScaling.Scale,
        Visible = windowScaling.Visible,

        Trails = TrailsShop,
        SelectedTrail = selectedTrail,
        EquippedTrail = player.Trails.EquippedId,
        OwnedTrails = player.Trails.OwnedIds,

        OnClose = function()
            WindowController.CloseWindow()
        end,

        OnTrailSelected = function(trail: Trails.TrailEntry)
            selectedTrail:set(trail)
        end,

        OnPurchase = function(trail: Trails.TrailEntry)
            TryPurchase(trail.Id)
        end,

        OnEquip = function(trail: Trails.TrailEntry?)
            TryEquip(if trail then trail.Id else nil)
        end,
    }

    local function Start()
        local screenGui = Instance.new("ScreenGui")
        screenGui.ResetOnSpawn = false
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

        trailsWindow.Parent = screenGui
        screenGui.Parent = player.Player.PlayerGui

        table.insert(scope, Observe.Character(player.Player, function(character: Model?)
            if not character then
                return
            end

            character:AddTag("CharacterTrail")
            
            local scope = scope:innerScope()

            scope:Observer(player.Trails.EquippedId):onBind(function()
                character:SetAttribute("TrailName", peek(player.Trails.EquippedId))
            end)

            return
        end))
    end

    local self: TrailsController = {
        TryPurchase = TryPurchase,
        TryEquip = TryEquip,

        Start = Start,
    }

    return self
end

return TrailsController
