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

    local section = scope:Value("Various")

    local skins = scope:Computed(function(use)
        if use(section) == "Various" then
            return SkinShop.Various
        end

        if use(section) == "Flags" then
            return SkinShop.Flags
        end

        error("Unknown section: " .. use(section))
    end)

    local entries = scope:Computed(function(use)
        local skinEntries: { SkinEntry } = {}

        for _, skin in use(skins) do
            local entry: SkinEntry = {
                Skin = skin,
                Owned = scope:Computed(function(use)
                    return use(ownedSkins)[skin.Id] == true
                end),
            }

            table.insert(skinEntries, entry)
        end

        return skinEntries
    end)

    local scale = scope:Value(1)

    local selected = scope:Value(Fusion.peek(entries)[1])
    local equipped = scope:Value(Fusion.peek(entries)[1].Skin)

    local window = scope:SkinsWindow {
        Scale = scale,
        
        Visible = scope:Computed(function(use)
            return use(scale) > 0.01
        end),

        Section = section,
        Skins = entries,
        Selected = selected,
        Equipped = equipped,

        OnSectionChange = function(sectionName)
            section:set(sectionName)
        end,

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
