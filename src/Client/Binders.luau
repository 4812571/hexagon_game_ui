local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage.Common
local Client = ReplicatedStorage.Client

local CollectionBinder = require(Common.Binder.CollectionBinder)
type CollectionBinder<B> = CollectionBinder.CollectionBinder<B>

local HexagonTile = require(Client.Hexagon.HexagonTile)
local CharacterCrown = require(Client.Crown.CharacterCrown)

type HexagonTile = HexagonTile.HexagonTile
type CharacterCrown = CharacterCrown.CharacterCrown

export type Binders = {
    HexagonTile: CollectionBinder<HexagonTile>,
    CharacterCrown: CollectionBinder<CharacterCrown>,
}

local Binders: Binders = {
    HexagonTile = CollectionBinder(HexagonTile),
    CharacterCrown = CollectionBinder(CharacterCrown),
}

return Binders