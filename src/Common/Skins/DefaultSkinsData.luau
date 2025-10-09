local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage.Common

local SkinsData = require(Common.Skins.SkinsData)
type SkinsData = SkinsData.SkinsData

local DefaultSkinsData: SkinsData = {
    OwnedSkins = {},
    ActiveSkinId = nil,
}

return DefaultSkinsData
