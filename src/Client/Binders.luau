local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage.Common
local Client = ReplicatedStorage.Client

local CollectionBinder = require(Common.Binder.CollectionBinder)
type CollectionBinder<B> = CollectionBinder.CollectionBinder<B>

local HexagonTile = require(Client.Hexagon.HexagonTile)

type HexagonTile = HexagonTile.HexagonTile

export type Binders = {
    HexagonTile: CollectionBinder<HexagonTile>,
}

local Binders: Binders = {
    HexagonTile = CollectionBinder(HexagonTile),
}

return Binders