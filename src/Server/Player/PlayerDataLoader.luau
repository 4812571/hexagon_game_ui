--!strict
--!native

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common

local Connect = require(Common.Connect)
local Signal = require(Common.Signal)
type Signal<T...> = Signal.Signal<T...>

local Fusion = require(Packages.Fusion)
type Scope = Fusion.Scope<unknown>

type Set<T> = { [T]: true }
type Map<K, V> = { [K]: V }

local ProfileService = require(Packages.ProfileService)

type ProfileStore<T> = {
    LoadProfileAsync: (ProfileStore<T>, string, string?) -> Profile<T>?,
}

export type Profile<T> = {
    Data: T,

    Release: (Profile<T>) -> (),
    ListenToRelease: (Profile<T>, () -> ()) -> (),
}

export type PlayerDataLoader<T> = {
    AddPlayer: (player: Player) -> (),
    RemovePlayer: (player: Player) -> (),

    GetProfile: (player: Player) -> Profile<T>?,
    AwaitProfile: (player: Player) -> Profile<T>?,

    ProfileLoaded: Signal<Player, Profile<T>>,
    ProfileReleased: Signal<Player, Profile<T>>,
}

local function PlayerDataLoader<T>(scope: Scope, profileStoreKey: string, defaultData: T): PlayerDataLoader<T>
    local profileStore: ProfileStore<T> = ProfileService.GetProfileStore(profileStoreKey, defaultData)

    local profileLoaded: Signal<Player, Profile<T>> = Signal(scope)
    local profileReleased: Signal<Player, Profile<T>> = Signal(scope)

    local profiles: Map<Player, Profile<T>> = {}
    local registered: Set<Player> = {}

    local function AddPlayer(player: Player)
        -- Register player
        registered[player] = true

        -- Load profile
        local profile = profileStore:LoadProfileAsync(tostring(player.UserId), "ForceLoad")

        -- Handle load failure
        if not profile then
            player:Kick("Could not load your data!")
            return
        end

        -- Handle player leaving during data load
        if not registered[player] then
            profile:Release()
            return
        end

        -- Reconcile default data with loaded data
        profile:Reconcile()

        -- Handle profile release
        profile:ListenToRelease(function()
            profileReleased:Fire(player, profile)
            player:Kick("Your data has been released!")
        end)

        registered[player] = true
        profiles[player] = profile

        profileLoaded:Fire(player, profile)
    end

    local function RemovePlayer(player: Player)
        local profile = profiles[player]

        if profile then
            profile:Release()
        end
        
        registered[player] = nil
        profiles[player] = nil
    end

    local function GetProfile(player: Player): Profile<T>?
        return profiles[player]
    end

    local awaitingThreads: Map<Player, {thread}> = {}

    Connect(scope, profileLoaded, function(player: Player, profile: Profile<T>)
        local threads = awaitingThreads[player]

        if not threads then
            return
        end

        for _, thread in threads do
            coroutine.resume(thread, profile)
        end

        awaitingThreads[player] = nil
    end)

    Connect(scope, profileReleased, function(player: Player, profile: Profile<T>)
        local threads = awaitingThreads[player]

        if not threads then
            return
        end

        for _, thread in threads do
            coroutine.resume(thread, nil)
        end

        awaitingThreads[player] = nil
    end)

    local function AwaitProfile(player: Player): Profile<T>?
        local loaded = profiles[player]

        if loaded then
            return loaded
        end

        local thread = coroutine.running()

        if not awaitingThreads[player] then
            awaitingThreads[player] = {}
        end

        table.insert(awaitingThreads[player], thread)

        return coroutine.yield() :: Profile<T>?
    end

    local self = {
        AddPlayer = AddPlayer,
        RemovePlayer = RemovePlayer,

        GetProfile = GetProfile,
        AwaitProfile = AwaitProfile,

        ProfileLoaded = profileLoaded,
        ProfileReleased = profileReleased,
    }

    return self
end

return PlayerDataLoader
