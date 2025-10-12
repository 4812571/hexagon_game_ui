local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common

local Fusion = require(Packages.Fusion)
local Children = Fusion.Children
local Out = Fusion.Out
local peek = Fusion.peek

local Clock = require(Common.Util.Clock)

return function(target: Instance)
    local scope = Fusion.scoped(Fusion, {
        Clock = Clock,
    })

    local now = scope:Clock()

    local alpha = scope:Computed(function(use)
        return (use(now) % 100) / 100
    end)

    local absoluteSize = scope:Value(Vector2.new(0, 0))

    local width = scope:Computed(function(use)
        return use(absoluteSize).X
    end)

    local height = scope:Computed(function(use)
        return use(absoluteSize).Y
    end)

    local barWidth = scope:Computed(function(use)
        return use(height) + use(alpha) * (use(width) - use(height))
    end)

    local barSize = scope:Computed(function(use)
        return UDim2.fromOffset(use(barWidth), use(height))
    end)

    local instance = scope:New "Frame" {
        Size = UDim2.fromOffset(300, 50),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.new(1, 1, 1),

        [Out "AbsoluteSize"] = absoluteSize,

        [Children] = {
            scope:New "UICorner" {
                CornerRadius = UDim.new(1, 0),
            },

            scope:New "UIStroke" {
                Thickness = 4,
                Color = Color3.fromRGB(0, 0, 0),
            },

            scope:New "Frame" {
                Size = barSize,
                Position = UDim2.fromScale(0, 0.50),
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = Color3.fromRGB(255, 0, 1),
                ZIndex = 0,

                [Children] = {
                    scope:New "UICorner" {
                        CornerRadius = UDim.new(1, 0),
                    },
                },
            },

            scope:New "TextLabel" {
                Size = UDim2.fromScale(1, 1),
                BackgroundTransparency = 1,
                Text = "Micahfication in progress...",
                TextSize = 24,
                Font = Enum.Font.FredokaOne,
                TextColor3 = Color3.fromRGB(255, 255, 255),

                [Children] = scope:New "UIStroke" {
                    Thickness = 2,
                    Color = Color3.fromRGB(0, 0, 0),
                }
            }
        },
    }

    instance.Parent = target

    return function()
        scope:doCleanup()
    end
end