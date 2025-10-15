--!strict
--!native
--!nolint LocalShadow

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)
local Children = Fusion.Children

local Icons = require(Common.Icons)

local Quests = require(Common.Quests.Quests)
type Quest = Quests.Quest

export type QuestEntry = {
    Quest: Quest,
    LayoutOrder: number,
    RewardExperience: Fusion.UsedAs<number>,
    Progress: Fusion.UsedAs<number>,
    RequiredProgress: Fusion.UsedAs<number>,
    
    OnClaim: () -> (),
}

local Window = require(Client.Interface.Window)
local QuestCard = require(Client.Quests.QuestCard)

type Scope<T> = Fusion.Scope<typeof(Fusion) & T>

export type Components = {
    Window: typeof(Window),
    QuestCard: typeof(QuestCard),
}

export type QuestsWindowProps = {
    Quests: { QuestEntry },
}

local function Pluralize(word: string, count: number): string
    return `{word}{if count == 1 then "" else "s"}`
end

local function QuestsWindow<U>(scope: Scope<U>, props: QuestsWindowProps)
    local scope: Scope<Components> = scope:innerScope {
        Window = Window,
        QuestCard = QuestCard,
    }

    return scope:Window {
        Title = "Quests",
        Icon = Icons.Scroll,
        IconScale = 1.20,

        Children = {
            scope:New "ScrollingFrame" {
                AutomaticSize = Enum.AutomaticSize.Y,
                Size = UDim2.fromScale(0.8, 0.8),
                Position = UDim2.fromScale(0.5, 0.5),
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundTransparency = 1,
                ScrollBarThickness = 12,
                ScrollingDirection = Enum.ScrollingDirection.Y,
                AutomaticCanvasSize = Enum.AutomaticSize.XY,
                BorderSizePixel = 0,

                [Children] = {
                    scope:New "UIListLayout" {
                        FillDirection = Enum.FillDirection.Vertical,
                        HorizontalAlignment = Enum.HorizontalAlignment.Center,
                        VerticalAlignment = Enum.VerticalAlignment.Top,
                        SortOrder = Enum.SortOrder.LayoutOrder,
                    },

                    scope:ForValues(props.Quests, function(use, scope: Scope<Components>, questEntry: QuestEntry)
                        local icon = scope:Computed(function(use)
                            local quest: Quest = use(questEntry.Quest)

                            if quest == "PlayTime" then
                                return Icons.Clock
                            end

                            if quest == "Color" then
                                return Icons.Pencil
                            end

                            if quest == "Elimination" then
                                return Icons.Sword
                            end

                            if quest == "Win" then
                                return Icons.Trophy
                            end

                            error("Unknown quest type: " .. tostring(quest))
                        end)

                        local text = scope:Computed(function(use)
                            local quest: Quest = use(questEntry.Quest)

                            if quest == "PlayTime" then
                                return `Play for {use(questEntry.RequiredProgress)} {Pluralize("minute", use(questEntry.RequiredProgress))}`
                            end

                            if quest == "Color" then
                                return `Collect {use(questEntry.RequiredProgress)} {Pluralize("coin", use(questEntry.RequiredProgress))}`
                            end

                            if quest == "Elimination" then
                                return `Eliminate {use(questEntry.RequiredProgress)} {Pluralize("player", use(questEntry.RequiredProgress))}`
                            end

                            if quest == "Win" then
                                return `Win {use(questEntry.RequiredProgress)} {Pluralize("game", use(questEntry.RequiredProgress))}`
                            end

                            error("Unknown quest type: " .. tostring(quest))
                        end)

                        return scope:QuestCard {
                            Size = UDim2.new(1, 0, 0, 90),

                            Icon = icon,
                            QuestText = text,
                            RewardExperience = questEntry.RewardExperience,
                            RequiredProgress = questEntry.RequiredProgress,
                            Progress = questEntry.Progress,
                            OnClaim = questEntry.OnClaim,

                            LayoutOrder = questEntry.LayoutOrder,
                        }
                    end),
                } :: {Fusion.Child}
            },
        },
    }
end

return QuestsWindow
