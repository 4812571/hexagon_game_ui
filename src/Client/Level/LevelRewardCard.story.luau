local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage.Common

local Packages = ReplicatedStorage.Packages

local Fusion = require(Packages.Fusion)

local Icons = require(Common.Icons)

local LevelRewardCard = require(script.Parent.LevelRewardCard)

return function(target: Instance)
    local scope = Fusion.scoped(Fusion, {
        LevelRewardCard = LevelRewardCard,
    })

    local state = scope:Value(1)

    local color = scope:Computed(function(use)
        if use(state) == 0 then
            return Color3.fromRGB(250, 83, 83)
        end

        if use(state) == 1 then
            return Color3.fromRGB(117, 154, 221)
        end

        if use(state) == 2 then
            return Color3.fromRGB(83, 250, 83)
        end

        error("Invalid state")
    end)

    local onClaim = scope:Computed(function(use)
        if use(state) == 0 or use(state) == 2 then
            return nil
        end

        return function()
            state:set(2)
        end
    end)

    local statusIcon = scope:Computed(function(use)
        if use(state) == 0 then
            return Icons.Lock
        end

        if use(state) == 1 then
            return nil
        end

        if use(state) == 2 then
            return Icons.Check
        end

        error("Invalid state")
    end)

    task.delay(3, function()
        state:set(1)
    end)

    local card = scope:LevelRewardCard {
        Size = UDim2.fromOffset(100, 135),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),

        Color = color,

        RewardIcon = Icons.Rebirth,
        StatusIcon = statusIcon,

        LevelText = "Level 5",
        RewardText = "+100 Rebirths",

        ClaimColor = Color3.fromRGB(0, 149, 235),

        OnClaim = onClaim,
    }

    card.Parent = target

    return function()
        scope:doCleanup()
    end
end