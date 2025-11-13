--!strict
--!native

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)
local peek = Fusion.peek

local SkinShop = require(Common.Skins.SkinShop)

local SkinsWindow = require(Client.Skins.SkinsWindow)
type SkinEntry = SkinsWindow.SkinEntry

return function(target: Instance)
    local scope = Fusion.scoped(Fusion, {
        SkinsWindow = SkinsWindow,
    })
    
    local ownedSkins = scope:Value({})

    local entries = {}

    for _, v in SkinShop.Flags do
        local entry: SkinEntry = {
            Skin = v :: SkinShop.SkinInfo,
            Owned = scope:Computed(function(use)
                return use(ownedSkins)[v.Id] == true
            end),
        }

        table.insert(entries, entry)
    end

    local scale = scope:Value(1)

    local selected = scope:Value(entries[1])
    local equipped = scope:Value(entries[1].Skin)

    local window = scope:SkinsWindow {
        Scale = scale,
        
        Visible = scope:Computed(function(use)
            return use(scale) > 0.01
        end),

        Section = "Various",
        Skins = entries,
        Selected = selected,
        Equipped = equipped,

        OnClose = function()
            print("SkinsWindow closed")
        end,

        OnSelect = function(entry: SkinEntry)
            selected:set(entry)
        end,

        OnPurchase = function(entry: SkinEntry)
            local currentOwned = peek(ownedSkins)
            currentOwned[entry.Skin.Id] = true
            ownedSkins:set(currentOwned)
        end,

        OnEquip = function(entry: SkinEntry?)
            equipped:set(if entry then entry.Skin else nil)
        end,
    }

    window.Parent = target

    return function()
        scope:doCleanup()
    end
end
