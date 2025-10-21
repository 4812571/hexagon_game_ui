--!strict
--!native

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages

local Fusion = require(Packages.Fusion)

type Scope = Fusion.Scope<typeof(Fusion)>
type Value<T> = Fusion.Value<T>

export type PlayerHexagons = {
    IsInGame: Value<boolean>,
    Tiles: Value<number>,
}

local function PlayerHexagons(scope: Scope): PlayerHexagons
    local isInGame = scope:Value(false)
    local tiles = scope:Value(0)

    return {
        IsInGame = isInGame,
        Tiles = tiles,
    }
end

return PlayerHexagons