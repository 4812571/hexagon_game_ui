local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages

local Fusion = require(Packages.Fusion)
local Children = Fusion.Children
local Out = Fusion.Out

type Scope<T> = Fusion.Scope<typeof(Fusion) & T>

type ProgressBarProps = {
    Size: Fusion.UsedAs<UDim2>?,
    Position: Fusion.UsedAs<UDim2>?,
    AnchorPoint: Fusion.UsedAs<Vector2>?,

    BarColor: Fusion.UsedAs<Color3>,
    BackgroundColor: Fusion.UsedAs<Color3>,

    Text: Fusion.UsedAs<string>,
    TextSize: Fusion.UsedAs<number>?,
    BarAlpha: Fusion.UsedAs<number>,

    Children: Fusion.Child?,
}

local function ProgressBar<U>(scope: Scope<U>, props: ProgressBarProps)
    local absoluteSize = scope:Value(Vector2.new(0, 0))

    local width = scope:Computed(function(use)
        return use(absoluteSize).X
    end)

    local height = scope:Computed(function(use)
        return use(absoluteSize).Y
    end)

    local barWidth = scope:Computed(function(use)
        return use(height) + use(props.BarAlpha) * (use(width) - use(height))
    end)

    local barSize = scope:Computed(function(use)
        return UDim2.fromOffset(use(barWidth), use(height))
    end)

    return scope:New "Frame" {
        Size = props.Size,
        Position = props.Position,
        AnchorPoint = props.AnchorPoint,
        BackgroundColor3 = props.BackgroundColor,

        [Out "AbsoluteSize"] = absoluteSize,

        [Children] = {
            props.Children,

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
                BackgroundColor3 = props.BarColor,
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
                Text = props.Text,
                TextSize = props.TextSize or 24,
                Font = Enum.Font.FredokaOne,
                TextColor3 = Color3.fromRGB(255, 255, 255),

                [Children] = scope:New "UIStroke" {
                    Thickness = 2,
                    Color = Color3.fromRGB(0, 0, 0),
                }
            }
        },
    }
end

return ProgressBar