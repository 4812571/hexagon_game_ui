local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)
local Children = Fusion.Children

local Icons = require(Common.Icons)

local LevelRewardCard = require(Client.Level.LevelRewardCard)

return function(target: Instance)
    local scope = Fusion.scoped(Fusion, {
        LevelRewardCard = LevelRewardCard,
    })


    local count = 50

    local numbers = scope:Computed(function(use)
        local nums = {}

        for i = 1, count do
            table.insert(nums, i)
        end

        return nums
    end)

    local scrollingFrame = scope:New "ScrollingFrame" {
        AutomaticSize = Enum.AutomaticSize.Y,
        Size = UDim2.fromOffset(600, 0),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        ScrollBarThickness = 12,
        ScrollingDirection = Enum.ScrollingDirection.X,
        AutomaticCanvasSize = Enum.AutomaticSize.XY,
        BorderSizePixel = 0,

        [Children] = {
            scope:New "UIListLayout" {
                FillDirection = Enum.FillDirection.Horizontal,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 10),
                HorizontalAlignment = Enum.HorizontalAlignment.Left,
                VerticalAlignment = Enum.VerticalAlignment.Top,
            },

            scope:New "UIPadding" {
                PaddingLeft = UDim.new(0, 20),
                PaddingRight = UDim.new(0, 20),
                PaddingTop = UDim.new(0, 10),
                PaddingBottom = UDim.new(0, 10),
            },

            scope:ForValues(numbers, function(num: number, scope): Fusion.Child
                return scope:LevelRewardCard {
                    Size = UDim2.fromOffset(200, 270),
                    Position = UDim2.fromScale(0.5, 0.5),
                    AnchorPoint = Vector2.new(0.5, 0.5),

                    Color = Color3.fromRGB(117, 154, 221),

                    RewardIcon = Icons.Rebirth,
                    StatusIcon = Icons.Check,

                    LevelText = "Level 5",
                    RewardText = "+100 Rebirths",

                    ClaimColor = Color3.fromRGB(0, 149, 235),

                    OnClaim = nil,
                }
            end)
        }
    }

    scrollingFrame.Parent = target

    return function()
        scope:doCleanup()
    end
end
