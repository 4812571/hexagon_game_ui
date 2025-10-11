--!strict
--!nolint LocalShadow

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common

local Fusion = require(Packages.Fusion)

type Scope<T> = Fusion.Scope<typeof(Fusion) & T>
type UsedAs<T> = Fusion.UsedAs<T>

local Icons = require(Common.Icons)
local Timer = require(Common.Util.Timer)

local IconText = require(script.Parent.IconText)

return function(target: Instance)
    local scope = Fusion.scoped(Fusion, {
        IconText = IconText,
    })

    local random = Random.new()
    local coinsAmount = scope:Value(0)

    table.insert(scope, Timer(4, function()
        coinsAmount:set(random:NextInteger(1000, 99999))
    end))

    local coinsSmooth = scope:Spring(coinsAmount, 35)

    local text = scope:Computed(function(use)
        return string.format("%d", use(coinsSmooth))
    end)

    local iconText = scope:IconText {
        Size = UDim2.fromOffset(300, 100),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),

        IconSide = "Left",
        Icon = Icons.Coin,

        Text = text,
        TextSize = 92,
        TextStrokeThickness = 4,
    }

    iconText.Parent = target

    return function()
        scope:doCleanup()
    end
end