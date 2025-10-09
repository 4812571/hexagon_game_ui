local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common

local Fusion = require(Packages.Fusion)
local peek = Fusion.peek

local CommonPlayer = require(Common.Player.CommonPlayer)
type CommonPlayer = CommonPlayer.CommonPlayer

local Quests = require(Common.Quests.Quests)
type QuestEntry = Quests.QuestEntry
type Quest = Quests.Quest

local function TypedQuest(questEntry: QuestEntry?, questType: Quest): QuestEntry?
    if not questEntry then
        return nil
    end

    if questEntry.Quest ~= questType then
        return nil
    end

    return questEntry
end

local function ProgressAll(player: CommonPlayer, questType: Quest, amount: number)
    for questId, progress in player.Quests.Progress do
        if TypedQuest(Quests[questId], questType) then
            progress:set(peek(progress) + amount)
        end
    end
end

return ProgressAll