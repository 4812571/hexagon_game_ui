--!strict

local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)
local peek = Fusion.peek
type Scope = Fusion.Scope<typeof(Fusion)>
type Value<T> = Fusion.Value<T>
type UsedAs<T> = Fusion.UsedAs<T>

local Music = require(Common.Music.Music)
local MusicOrder = require(Common.Music.MusicOrder)
type Music = Music.Music

local ClientPlayer = require(Client.Player.ClientPlayer)
type ClientPlayer = ClientPlayer.ClientPlayer

local MusicPlayer = require(Client.Music.MusicPlayer)

local function CircularIndex(index: number, length: number): number
    return ((index - 1) % length) + 1
end

local function ObserveValue<T>(scope: Scope, value: UsedAs<T>, fn: (T, Scope) -> ())
    local previousScope: Scope? = nil

    scope:Observer(value):onBind(function()
        if previousScope then
            previousScope:doCleanup()
        end
        
        local newScope = scope:innerScope()
        fn(peek(value), newScope)

        previousScope = newScope
    end)
end

export type MusicController = {
    Start: () -> (),
}

local function MusicController(scope: Scope, player: ClientPlayer): MusicController
    local sounds: {[Music]: Sound} = {}

    for _, music in MusicOrder do
        local sound = Instance.new("Sound")
        sound.Name = music.Name
        sound.SoundId = music.Link
        sound.Looped = false
        sound.Parent = SoundService

        sounds[music] = sound
    end

    local isPlaying = scope:Value(true)
    local playerIndex = scope:Value(1)
    
    local activeSoundIndex: UsedAs<number> = scope:Computed(function(use)
        return CircularIndex(use(playerIndex), #MusicOrder)
    end)

    local activeMusic: UsedAs<Music> = scope:Computed(function(use)
        return MusicOrder[use(activeSoundIndex)]
    end)

    local activeSound: UsedAs<Sound> = scope:Computed(function(use)
        return sounds[use(activeMusic)]
    end)

    local function NextSong()
        playerIndex:set(peek(playerIndex) + 1)
    end

    local function PreviousSong()
        playerIndex:set(peek(playerIndex) - 1)
    end

    local function Start()
        for _, sound: Sound in sounds do
            table.insert(scope, sound.Ended:Connect(NextSong))
        end

        ObserveValue(scope, activeSound, function(sound: Sound, scope: Scope)
            ObserveValue(scope, isPlaying, function(playing: boolean)
                if playing then
                    sound:Resume()
                else
                    sound:Pause()
                end
            end)

            table.insert(scope, function()
                sound:Stop()
            end)
        end)

        local progress = scope:Value(0)


        ObserveValue(scope, activeSound, function(sound: Sound, scope: Scope)
            table.insert(scope, RunService.RenderStepped:Connect(function()
                progress:set(sound.TimePosition)
            end))
        end)

        local musicPlayer = MusicPlayer {
            Scope = scope,

            Title = scope:Computed(function(use)
                return use(activeMusic).Name
            end),

            Progress = progress,
            Playing = isPlaying,

            TogglePlayback = function()
                isPlaying:set(not peek(isPlaying))
            end,

            NextSong = NextSong,
            PreviousSong = PreviousSong,
        }

        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "Music"

        musicPlayer.Parent = screenGui
        screenGui.Parent = player.Player.PlayerGui
    end

    local self: MusicController = {
        Start = Start,
    }

    return self
end

return MusicController