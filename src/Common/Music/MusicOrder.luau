local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage.Common

local Music = require(Common.Music.Music)
type Music = Music.Music

local MusicOrder: {Music} = {
    Music.GotMe,
    Music.YouAndMe,
    Music.Escape,
    Music.Braziliana,
    Music.Happy,
    Music.Horizons,
    Music.Expedition,
    Music.CrabRave,
}

return MusicOrder