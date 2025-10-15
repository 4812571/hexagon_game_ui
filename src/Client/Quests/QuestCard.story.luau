--!strict
--!native
--!nolint LocalShadow

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common

local Fusion = require(Packages.Fusion)
local peek = Fusion.peek

local Icons = require(Common.Icons)

local QuestCard = require(script.Parent.QuestCard)

return function(target: Instance)
    local scope = Fusion.scoped(Fusion, {
        QuestCard = QuestCard,
    })

    local progress = scope:Value(50)
    local requiredProgress = 5

    local card = scope:QuestCard {
        Size = UDim2.fromOffset(668, 78),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),

        Icon = Icons.Clock,
        QuestText = "Play for 5 minutes",
        RewardExperience = 25,

        Progress = progress,
        RequiredProgress = requiredProgress,

        OnClaim = function()
            if peek(progress) < peek(requiredProgress) then
                return
            end

            progress:set(peek(progress) - peek(requiredProgress))
        end,
    }

    card.Parent = target

    return function()
        scope:doCleanup()
    end
end