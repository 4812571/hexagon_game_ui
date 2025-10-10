local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)
local peek = Fusion.peek
type Scope = Fusion.Scope<typeof(Fusion)>
type Value<T> = Fusion.Value<T>

local Quests = require(Common.Quests.Quests)
local ProgressAll = require(Common.Quests.ProgressAll)

local NetworkClient = require(ReplicatedStorage.NetworkClient)

local ClientPlayer = require(Client.Player.ClientPlayer)
type ClientPlayer = ClientPlayer.ClientPlayer

export type QuestsController = {
    TryClaim: (id: string) -> boolean,
    Start: () -> (),
}

local function QuestsController(scope: Scope, player: ClientPlayer): QuestsController
    local function TryClaim(id: string): boolean
        local questEntry: Quests.QuestEntry = Quests[id]

        if not questEntry then
            warn("[QuestsController] Invalid quest id: " .. id)
            return false
        end

        local progress: Value<number>? = player.Quests.Progress[id]

        if not progress then
            warn("[QuestsController] No progress found for quest id: " .. id)
            return false
        end

        if peek(progress) < questEntry.RequiredProgress then
            return false
        end

        local totalExperience = player.Level.TotalExperience

        progress:set(peek(progress) - questEntry.RequiredProgress)
        totalExperience:set(peek(totalExperience) + questEntry.RewardExperience)

        NetworkClient.Quests.ClaimQuest.Invoke(id)
        return true
    end

    local function OnMinutePassed()
        ProgressAll(player, "PlayTime", 1)
    end

    local function OnClaimed(outer: number, inner: number)
        ProgressAll(player, "Color", outer + inner)
    end

    local function OnPlayerKilled(killer: Player, victim: Player)
        if killer ~= player.Player then
            return
        end

        ProgressAll(player, "Elimination", 1)
    end

    local function OnPlayerWon(winner: Player)
        if winner ~= player.Player then
            return
        end

        ProgressAll(player, "Win", 1)
    end

    local function Start()
        NetworkClient.PlayTime.MinutePassed.On(OnMinutePassed)
        NetworkClient.Hexagon.Claimed.On(OnClaimed)
        NetworkClient.Hexagon.PlayerKilled.On(OnPlayerKilled)
        NetworkClient.Hexagon.PlayerWon.On(OnPlayerWon)
    end

    local self: QuestsController = {
        TryClaim = TryClaim,
        Start = Start,
    }

    return self
end

return QuestsController