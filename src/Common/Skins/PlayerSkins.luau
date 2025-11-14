--!strict
--!native

local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common

local Fusion = require(Packages.Fusion)
local peek = Fusion.peek
type Scope = Fusion.Scope<typeof(Fusion)>
type Value<T> = Fusion.Value<T>
type UsedAs<T> = Fusion.UsedAs<T>

local Skins = require(Common.Skins.Skins)
type SkinInfo = Skins.SkinInfo

local SkinsData = require(Common.Skins.SkinsData)
type SkinsData = SkinsData.SkinsData

export type PlayerSkins = {
    OwnedSkins: Value<{[string]: boolean}>,
    ActiveSkinId: Value<string?>,
    SkinImage: UsedAs<string?>,

    HasSkin: (id: string) -> boolean,
    AddSkin: (id: string) -> (),
}

local function PlayerSkins(scope: Scope, data: SkinsData): PlayerSkins
    local ownedSkins = scope:Value(data.OwnedSkins)
    local activeSkinId = scope:Value(data.ActiveSkinId)

    if RunService:IsServer() then
        scope:Observer(ownedSkins):onChange(function()
            data.OwnedSkins = peek(ownedSkins)
        end)

        scope:Observer(activeSkinId):onChange(function()
            data.ActiveSkinId = peek(activeSkinId)
        end)
    end

    local skinImage = scope:Computed(function(use): string?
        local skinId = use(activeSkinId)

        if not skinId then
            return nil
        end

        local skinInfo: SkinInfo? = Skins[skinId]

        if not skinInfo then
            return nil
        end

        return skinInfo.ImageId
    end)

    local function HasSkin(id: string): boolean
        return peek(ownedSkins)[id] == true
    end

    local function AddSkin(id: string)
        local skins = peek(ownedSkins)
        skins[id] = true
        ownedSkins:set(skins)
    end

    local self: PlayerSkins = {
        OwnedSkins = ownedSkins,
        ActiveSkinId = activeSkinId,
        SkinImage = skinImage,

        HasSkin = HasSkin,
        AddSkin = AddSkin,
    }

    return self
end

return PlayerSkins
