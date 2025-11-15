--!strict
--!native

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common

local Fusion = require(Packages.Fusion)

local Icons = require(Common.Icons)

local Clock = require(Common.Util.Clock)

local BombCard = require(script.Parent.BombCard)

return function(target: Instance)
    local scope = Fusion.scoped(Fusion, {
        Clock = Clock,
        BombCard = BombCard,
    })

    local lastUsed = scope:Value(0)
    local now = scope:Clock()

    local timeSinceUse = scope:Computed(function(use)
        return (use(now) :: number) - use(lastUsed)
    end)

    local cooldown = scope:Computed(function(use)
        return math.clamp(5.0 - use(timeSinceUse), 0, 5.0)
    end)

    local instance = scope:BombCard {
        Size = UDim2.fromOffset(180, 180),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
    
        Transparency = 0.75,

        Cooldown = cooldown,

        BombIcon = Icons.GoldenBomb,
        Count = 80,

        Activated = function()
            if Fusion.peek(cooldown) > 0 then
                return
            end

            lastUsed:set(workspace:GetServerTimeNow())
        end,
    }

    instance.Parent = target

    return function()
        scope:doCleanup()
    end
end