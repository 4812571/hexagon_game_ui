--!strict
--!native

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage.Common
local Client = ReplicatedStorage.Client

local CollectionBinder = require(Common.Binder.CollectionBinder)
type CollectionBinder<B> = CollectionBinder.CollectionBinder<B>

local HexagonTile = require(Client.Hexagon.HexagonTile)
local CharacterCrown = require(Client.Crown.CharacterCrown)
local CharacterTrail = require(Client.Trails.CharacterTrail)

type HexagonTile = HexagonTile.HexagonTile
type CharacterCrown = CharacterCrown.CharacterCrown
type CharacterTrail = CharacterTrail.CharacterTrail

export type Binders = {
    HexagonTile: CollectionBinder<HexagonTile>,
    CharacterCrown: CollectionBinder<CharacterCrown>,
}

local Binders: Binders = {
    HexagonTile = CollectionBinder(HexagonTile),
    CharacterCrown = CollectionBinder(CharacterCrown),
    CharacterTrail = CollectionBinder(CharacterTrail),
}

return Binders
