local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)

local Frame = require(Client.Interface.Frame)
local TextLabel = require(Client.Interface.TextLabel)
local EmbossedFrame = require(Client.Interface.EmbossedFrame)

export type ProgressBarProps = {
    Scope: Fusion.Scope<typeof(Fusion)>,

    Name: Fusion.UsedAs<string>?,

    BackgroundColor3: Fusion.UsedAs<Color3>,

    Progress: Fusion.UsedAs<number>,

    Text: Fusion.UsedAs<string>,

    AnchorPoint: Fusion.UsedAs<Vector2>?,
    Position: Fusion.UsedAs<UDim2>?,
    Size: Fusion.UsedAs<UDim2>?,

    PaddingBottom: Fusion.UsedAs<UDim>?,

    Children: Fusion.Child?,
}

local function ProgressBar(props: ProgressBarProps)
    local scope = props.Scope

    local bottomPadding = props.PaddingBottom or UDim.new(0, 5)

    return Frame {
        Scope = scope,

        Name = props.Name or "ProgressBar",

        BackgroundTransparency = 1,

        AnchorPoint = props.AnchorPoint,
        Position = props.Position,
        Size = props.Size,

        Children = {
            EmbossedFrame {
                Scope = scope,

                Name = "Background",

                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(1, 1),

                CornerRadius = UDim.new(0, 5),

                PaddingBottom = bottomPadding,

                BackgroundColor3 = Color3.fromRGB(27, 27, 29),
            },

            EmbossedFrame {
                Scope = scope,

                Name = "Fill",

                AnchorPoint = Vector2.new(0, 0.5),
                Position = UDim2.fromScale(0, 0.5),
                Size = scope:Computed(function(use)
                    return UDim2.fromScale(use(props.Progress), 1)
                end),

                CornerRadius = UDim.new(0, 5),

                PaddingBottom = bottomPadding,

                BackgroundColor3 = props.BackgroundColor3,

                StrokeThickness = 0,
            },

            TextLabel {
                Scope = scope,

                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(1, 1),

                AutomaticSize = Enum.AutomaticSize.XY,

                TextXAlignment = Enum.TextXAlignment.Center,
                TextYAlignment = Enum.TextYAlignment.Center,

                Text = props.Text,

                Children = scope:New "UIPadding" {
                    PaddingBottom = scope:Computed(function(use)
                        return use(bottomPadding) :: UDim + UDim.new(0, 10)
                    end),
                    PaddingTop = UDim.new(0, 10),
                    PaddingLeft = UDim.new(0, 20),
                    PaddingRight = UDim.new(0, 20),
                },
            },

            Children = props.Children,
        }
    }
end

return ProgressBar