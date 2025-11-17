--!strict
--!native
--!nolint LocalShadow

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)
local Children = Fusion.Children
local Out = Fusion.Out

local Text = require(Client.Interface.Text)

type Scope<T> = Fusion.Scope<typeof(Fusion) & T>

export type Components = {
    Text: typeof(Text),
}

export type ProgressBarProps = {
    Size: Fusion.UsedAs<UDim2>?,
    Position: Fusion.UsedAs<UDim2>?,
    AnchorPoint: Fusion.UsedAs<Vector2>?,

    LayoutOrder: Fusion.UsedAs<number>?,

    BarColor: Fusion.UsedAs<Color3>,
    BackgroundColor: Fusion.UsedAs<Color3>,

    Text: Fusion.UsedAs<string>,
    TextSize: Fusion.UsedAs<number>,
    BarAlpha: Fusion.UsedAs<number>,

    Children: Fusion.Child?,
}

local SCALE_WATCH_RESOLUTION = 10 * 1000

local function ProgressBar<U>(scope: Scope<U>, props: ProgressBarProps)
    local scope: Scope<Components> = scope:innerScope {
        Text = Text,
    }
    
    local absoluteSize = scope:Value(Vector2.new(0, 0))

    local scalarSize = scope:Value(Vector2.new(0, 0))

    local appliedScale = scope:Computed(function(use)
        return use(scalarSize).X / SCALE_WATCH_RESOLUTION
    end)

    local width = scope:Computed(function(use)
        return use(absoluteSize).X // use(appliedScale)
    end)

    local height = scope:Computed(function(use)
        return use(absoluteSize).Y // use(appliedScale)
    end)

    local barWidth = scope:Computed(function(use)
        return use(height) + (use(props.BarAlpha) :: number) * (use(width) - use(height))
    end)

    local barSize = scope:Computed(function(use)
        return UDim2.fromOffset(use(barWidth), use(height))
    end)

    return scope:New "Frame" {
        Size = props.Size,
        Position = props.Position,
        AnchorPoint = props.AnchorPoint,
        BackgroundColor3 = props.BackgroundColor,
        LayoutOrder = props.LayoutOrder,

        [Out "AbsoluteSize"] = absoluteSize,

        [Children] = {
            props.Children,

            scope:New "Frame" {
                Visible = false,
                BackgroundTransparency = 1,
                Size = UDim2.fromOffset(SCALE_WATCH_RESOLUTION, SCALE_WATCH_RESOLUTION),
                [Out "AbsoluteSize"] = scalarSize,
            },

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

            scope:Text {
                Text = props.Text,
                TextSize = props.TextSize,

                StrokeSize = 2.0,
            }
        },
    }
end

return ProgressBar