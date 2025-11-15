--!strict
--!native
--!nolint LocalShadow

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)

local Icons = require(Common.Icons)

local BombWindow = require(Client.Bombs.BombWindow)

local function Rainbow(n: number, offset: number): ColorSequence
    local keypoints = {}

    for i = 0, n - 1 do
        local unitPosition = i / (n - 1)
        local hue = (unitPosition + offset) % 1
        local color = Color3.fromHSV(hue, 1, 1)
        table.insert(keypoints, ColorSequenceKeypoint.new(unitPosition, color))
    end

    return ColorSequence.new(keypoints)
end

return function(target: Instance)
    local scope = Fusion.scoped(Fusion, {
        BombWindow = BombWindow,
    })

    local random = Random.new()

    local bomb: BombWindow.BombEntry = {
        Icon = Icons.Bomb,
        Count = random:NextInteger(1, 100),
        Cooldown = 0.0,

        CardTransparency = 0.5,

        Activated = function()
            print("Bomb activated!")
        end,
    }

    local goldBomb: BombWindow.BombEntry = {
        Icon = Icons.GoldenBomb,
        Count = random:NextInteger(1, 100),
        Cooldown = 0.0,

        CardTransparency = 0.5,

        Activated = function()
            print("Golden bomb activated!")
        end,
    }

    local nuke: BombWindow.BombEntry = {
        Icon = Icons.Rocket,
        Count = random:NextInteger(1, 100),
        Cooldown = 0.0,

        CardGradient = scope:New "UIGradient" {
            Color = scope:Computed(function(use)
                return Rainbow(5, 0.85)
            end),
            Rotation = 120,
        },

        Activated = function()
            print("Nuke activated!")
        end,
    }

    local instance = scope:BombWindow {
        Size = UDim2.fromOffset(600, 200),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),

        Bombs = {bomb, goldBomb, nuke},
    }

    instance.Parent = target

    return function()
        scope:doCleanup()
    end
end