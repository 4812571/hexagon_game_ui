--!strict
--!native

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages

local Fusion = require(Packages.Fusion)

local peek = Fusion.peek

local MusicPlayer = require(script.Parent.MusicPlayer)

return function(target: Instance)
    local scope = Fusion.scoped(Fusion)

    local playing = scope:Value(true)

    local instance = MusicPlayer {
        Scope = scope,

        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.fromScale(1, 0) + UDim2.fromOffset(-10, 10),

        Title = "Rab Crave",
        Progress = 30,
        Playing = playing,

        TogglePlayback = function()
            print("toggle playback clicked")

            playing:set(not peek(playing))
        end,

        NextSong = function()
            print("next song clicked")
        end,
        PreviousSong = function()
            print("previous song clicked")
        end
    }

    instance.Parent = target

    return function()
        scope:doCleanup()
    end
end
