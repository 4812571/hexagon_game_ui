--!strict
--!native

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)

local SkinShop = require(Common.Skins.SkinShop)

local SkinsWindow = require(Client.Skins.SkinsWindow)
type SkinEntry = SkinsWindow.SkinEntry

return function(target: Instance)
    local scope = Fusion.scoped(Fusion, {
        SkinsWindow = SkinsWindow,
    })

    local entries = {}

    local random = Random.new()

    for _, v in SkinShop do
        local entry: SkinEntry = {
            Skin = v :: SkinShop.SkinInfo,
            Owned = random:NextNumber() < 0.25,
        }

        table.insert(entries, entry)
    end

    local window = scope:SkinsWindow {
        Section = "Various",
        Skins = entries,
        Selected = entries[1],
    }

    window.Parent = target

    return function()
        scope:doCleanup()
    end
end
