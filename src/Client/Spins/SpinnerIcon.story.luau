--!strict
--!native

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common

local Fusion = require(Packages.Fusion)
local Children = Fusion.Children

local Icons = require(Common.Icons)

local SpinnerIcon = require(script.Parent.SpinnerIcon)

local Clock = require(Common.Util.Clock)

type SpinnerIconDescription = {
    Icon: string,
    Text: string,
    Scale: number,
}

local function SpinnerIconDescription(icon: string, text: string, scale: number?): SpinnerIconDescription
    local spinnerIconDescription: SpinnerIconDescription = {
        Icon = icon,
        Text = text,
        Scale = if scale then scale else 1,
    }

    return spinnerIconDescription
end

local descriptions: {SpinnerIconDescription} = {
    SpinnerIconDescription(Icons.Rocket, "NUKE"),
    SpinnerIconDescription(Icons.Heart, "+1"),
    SpinnerIconDescription(Icons.Bomb, "+3"),
    SpinnerIconDescription(Icons.Coin, "+5k"),
    SpinnerIconDescription(Icons.Coin, "x5"),
    SpinnerIconDescription(Icons.Spinner, "+3"),
    SpinnerIconDescription(Icons.Bomb, "+2"),
    SpinnerIconDescription(Icons.Coin, "+10k"),
}

local SHOW_TIME = 1.2


type Scope<T> = Fusion.Scope<typeof(Fusion) & T>

type Components = {
    Clock: typeof(Clock),
    SpinnerIcon: typeof(SpinnerIcon),
}

return function(target: Instance)
    local scope: Scope<Components> = Fusion.scoped(Fusion, {
        Clock = Clock,
        SpinnerIcon = SpinnerIcon,
    })

    local now = scope:Clock()

    local selectedIndex = scope:Computed(function(use)
        return (((use(now) :: number) // SHOW_TIME) % #descriptions) + 1
    end)

    local selectedDescription = scope:Computed(function(use)
        return descriptions[use(selectedIndex)]
    end)

    local frame = scope:New "Frame" {
        Size = UDim2.fromOffset(120, 120),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),

        BackgroundTransparency = 1,

        [Children] = scope:Computed(function(use, scope: Scope<Components>): Instance
            return scope:SpinnerIcon {
                Size = UDim2.fromScale(1, 1),
                Position = UDim2.fromScale(0.5, 0.5),
                AnchorPoint = Vector2.new(0.5, 0.5),

                Icon = use(selectedDescription).Icon,
                Text = use(selectedDescription).Text,
                IconScale = use(selectedDescription).Scale,
            }
        end),
    }

    frame.Parent = target

    return function()
        scope:doCleanup()
    end
end