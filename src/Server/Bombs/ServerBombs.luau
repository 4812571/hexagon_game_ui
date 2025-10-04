local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common

local Fusion = require(Packages.Fusion)
local peek = Fusion.peek
type Scope = Fusion.Scope<typeof(Fusion)>
type Value<T> = Fusion.Value<T>

local BombsData = require(Common.Bombs.BombsData)
type BombsData = BombsData.BombsData

export type ServerBombs = {
    Bombs: Value<number>,
    GoldBombs: Value<number>,
    Nukes: Value<number>,
}

local function ServerBombs(scope: Scope, data: BombsData): ServerBombs
    local bombs = scope:Value(data.Bombs)
    local goldBombs = scope:Value(data.GoldBombs)
    local nukes = scope:Value(data.Nukes)

    scope:Observer(bombs):onChange(function()
        data.Bombs = peek(bombs)
    end)

    scope:Observer(goldBombs):onChange(function()
        data.GoldBombs = peek(goldBombs)
    end)

    scope:Observer(nukes):onChange(function()
        data.Nukes = peek(nukes)
    end)

    local self = {
        Bombs = bombs,
        GoldBombs = goldBombs,
        Nukes = nukes,
    }

    return self
end

return ServerBombs