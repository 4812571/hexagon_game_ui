local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common

local Fusion = require(Packages.Fusion)
type Scope = Fusion.Scope<typeof(Fusion)>
type Value<T> = Fusion.Value<T>

local BombsData = require(Common.Bombs.BombsData)
type BombsData = BombsData.BombsData

export type ClientBombs = {
    Bombs: Value<number>,
    GoldBombs: Value<number>,
    Nukes: Value<number>,
}

local function ClientBombs(scope: Scope, data: BombsData): ClientBombs
    local bombs = scope:Value(data.Bombs)
    local goldBombs = scope:Value(data.GoldBombs)
    local nukes = scope:Value(data.Nukes)

    local self = {
        Bombs = bombs,
        GoldBombs = goldBombs,
        Nukes = nukes,
    }

    return self
end

return ClientBombs