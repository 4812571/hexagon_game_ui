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

    LastBombTime: Value<number>,
    LastGoldBombTime: Value<number>,
    LastNukeTime: Value<number>,
}

local function ClientBombs(scope: Scope, data: BombsData): ClientBombs
    local bombs = scope:Value(data.Bombs)
    local goldBombs = scope:Value(data.GoldBombs)
    local nukes = scope:Value(data.Nukes)

    local lastBombTime = scope:Value(0)
    local lastGoldBombTime = scope:Value(0)
    local lastNukeTime = scope:Value(0)

    local self = {
        Bombs = bombs,
        GoldBombs = goldBombs,
        Nukes = nukes,

        LastBombTime = lastBombTime,
        LastGoldBombTime = lastGoldBombTime,
        LastNukeTime = lastNukeTime,
    }

    return self
end

return ClientBombs