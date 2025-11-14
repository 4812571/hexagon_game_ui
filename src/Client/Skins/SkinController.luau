--!strict
--!native
--!nolint LocalShadow

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)

local Skins = require(Common.Skins.Skins)
type SkinInfo = Skins.SkinInfo

local SkinShop = require(Common.Skins.SkinShop)

local NetworkClient = require(ReplicatedStorage.NetworkClient)

local ClientPlayer = require(Client.Player.ClientPlayer)
type ClientPlayer = ClientPlayer.ClientPlayer

local WindowController = require(Client.Window.WindowController)
local WindowScaling = require(Client.Window.WindowScaling)

local SkinsWindow = require(Client.Skins.SkinsWindow)

export type Controllers = {
    WindowController: WindowController.WindowController,
}

export type SkinController = {
    TryPurchase: (skinId: string) -> boolean,
    TryEquip: (skinId: string?) -> boolean,
    Start: () -> (),
}

type Scope<T> = Fusion.Scope<typeof(Fusion) & T>

export type Components = {
    WindowScaling: typeof(WindowScaling),
    SkinsWindow: typeof(SkinsWindow),
}

local function SkinController(scope: Scope<{}>, player: ClientPlayer, controllers: Controllers): SkinController
    local WindowController = controllers.WindowController

    local scope: Scope<Components> = scope:innerScope {
        WindowScaling = WindowScaling,
        SkinsWindow = SkinsWindow,
    }

    local function TryPurchase(skinId: string): boolean
        local skinInfo: SkinInfo = Skins[skinId]

        if not skinInfo then
            warn("SkinController: TryPurchase - Invalid skin ID:", skinId)
            return false
        end

        if player.Skins.HasSkin(skinId) then
            return false
        end

        if not player.Coins.ConsumeCoins(skinInfo.Price) then
            return false
        end

        player.Skins.AddSkin(skinId)
        NetworkClient.Skins.PurchaseSkin.Invoke(skinId)

        return true
    end

    local function TryEquip(skinId: string?): boolean
        if skinId and not player.Skins.HasSkin(skinId) then
            return false
        end

        player.Skins.ActiveSkinId:set(skinId)
        NetworkClient.Skins.EquipSkin.Invoke(skinId)
        return true
    end

    local windowScaling = scope:WindowScaling("Skins", WindowController.CurrentWindow)

    local skinEntries = {}

    for skinId: string, skinInfo: SkinInfo in Skins :: { [string]: SkinInfo } do
        local entry: SkinsWindow.SkinEntry = {
            Skin = skinInfo,
            Owned = scope:Computed(function(use)
                return use(player.Skins.OwnedSkins)[skinId] == true
            end)
        }

        skinEntries[skinInfo] = entry
    end

    local variousEntries = {}

    for _, skinInfo: SkinInfo in SkinShop.Various do
        table.insert(variousEntries, skinEntries[skinInfo])
    end

    local flagEntries = {}

    for _, skinInfo: SkinInfo in SkinShop.Flags do
        table.insert(flagEntries, skinEntries[skinInfo])
    end

    local selected = scope:Value(flagEntries[1])
    local section: Fusion.Value<SkinsWindow.SkinSection> = scope:Value("Various") :: any

    local skinsWindow = scope:SkinsWindow {
        Scale = windowScaling.Scale,
        Visible = windowScaling.Visible,
        Selected = selected,

        Skins = flagEntries,
        Section = section,

        Equipped = scope:Computed(function(use)
            local activeSkinId = use(player.Skins.ActiveSkinId)

            if not activeSkinId then
                return nil
            end

            return Skins[activeSkinId]
        end),

        OnSelect = function(entry: SkinsWindow.SkinEntry)
            selected:set(entry)
        end,

        OnClose = function()
            WindowController.CloseWindow()
        end,

        OnPurchase = function(entry: SkinsWindow.SkinEntry)
            TryPurchase(entry.Skin.Id)
        end,

        OnEquip = function(entry: SkinsWindow.SkinEntry?)
            TryEquip(if entry then entry.Skin.Id else nil)
        end,
    }

    local function Start()
        local screenGui = Instance.new("ScreenGui")
        screenGui.ResetOnSpawn = false
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

        skinsWindow.Parent = screenGui
        screenGui.Parent = player.Player.PlayerGui
    end

    local self: SkinController = {
        TryPurchase = TryPurchase,
        TryEquip = TryEquip,
        Start = Start,
    }

    return self
end

return SkinController
