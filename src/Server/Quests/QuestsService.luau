--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Server = ServerScriptService.Server

local Fusion = require(Packages.Fusion)
local peek = Fusion.peek
type Scope = Fusion.Scope<typeof(Fusion)>
type Value<T> = Fusion.Value<T>

local Terminate = require(Common.Player.Terminate)
local ProgressAll = require(Common.Quests.ProgressAll)

local Quests = require(Common.Quests.Quests)
type QuestEntry = Quests.QuestEntry

local NetworkServer = require(ServerScriptService.NetworkServer)

local PlayerService = require(Server.Player.PlayerService)
local PlayTimeService = require(Server.PlayTime.PlayTimeService)
local HexagonService = require(Server.Hexagon.HexagonService)

type HexagonPlayer = HexagonService.HexagonPlayer

export type Services = {
    PlayerService: PlayerService.PlayerService,
    PlayTimeService: PlayTimeService.PlayTimeService,
    HexagonService: HexagonService.HexagonService,
}

export type QuestsService = {
    Init: () -> (),
    Start: () -> (),
}

local function QuestsService(scope: Scope, services: Services): QuestsService
    local PlayerService = services.PlayerService
    local PlayTimeService = services.PlayTimeService
    local HexagonService = services.HexagonService

    local function OnMinute()
        for _, serverPlayer in PlayerService.GetAll() do
            ProgressAll(serverPlayer, "PlayTime", 1)
        end
    end

    local function OnClaim(player: HexagonPlayer, outer: number, inner: number)
        ProgressAll(player.Player, "Color", outer + inner)
    end

    local function OnKill(killer: HexagonPlayer, victim: HexagonPlayer)
        ProgressAll(killer.Player, "Elimination", 1)
    end

    local function OnWin(winner: HexagonPlayer)
        ProgressAll(winner.Player, "Win", 1)
    end

    local function Init()
        table.insert(scope, PlayTimeService.MinuteSignal:Connect(OnMinute))
        table.insert(scope, HexagonService.Claimed:Connect(OnClaim))
        table.insert(scope, HexagonService.PlayerKilled:Connect(OnKill))
        table.insert(scope, HexagonService.PlayerWon:Connect(OnWin))
    end

    local function Start()
        NetworkServer.Quests.ClaimQuest.On(function(player: Player, questId: string): ()
            local serverPlayer = PlayerService.Expect(player)

            local questEntry: QuestEntry = Quests[questId]

            if not questEntry then
                return Terminate(player, "[QuestsService] Invalid quest id: " .. questId)
            end

            local progress: Value<number>? = serverPlayer.Quests.Progress[questId]

            if not progress then
                return Terminate(player, "[QuestsService] No progress found for quest id: " .. questId)
            end

            if peek(progress) < questEntry.RequiredProgress then
                return Terminate(player, "[QuestsService] Not enough progress for quest id: " .. questId)
            end

            local totalExperience = serverPlayer.Level.TotalExperience

            progress:set(peek(progress) - questEntry.RequiredProgress)
            totalExperience:set(peek(totalExperience) + questEntry.RewardExperience)
        end)
    end

    local self: QuestsService = {
        Init = Init,
        Start = Start,
    }

    return self
end

return QuestsService