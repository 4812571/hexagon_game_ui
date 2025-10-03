local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)

local Icons = require(Common.Icons)

local Frame = require(Client.Interface.Frame)
local ListLayout = require(Client.Interface.ListLayout)
local TextLabel = require(Client.Interface.TextLabel)
local IconButton = require(Client.Interface.IconButton)

local function formatTime(seconds: number)
    local minutes = seconds // 60
    seconds %= 60

    return string.format("%02d:%02d", minutes, seconds)
end

export type MusicPlayerProps = {
    Scope: Fusion.Scope<typeof(Fusion)>,

    LayoutOrder: Fusion.UsedAs<number>?,

    AnchorPoint: Fusion.UsedAs<Vector2>?,
    Position: Fusion.UsedAs<UDim2>?,
    Size: Fusion.UsedAs<UDim2>?,

    Title: Fusion.UsedAs<string>,
    Progress: Fusion.UsedAs<number>,
    Playing: Fusion.UsedAs<boolean>,

    TogglePlayback: () -> ()?,

    NextSong: () -> ()?,
    PreviousSong: () -> ()?,
}

local function MusicPlayer(props: MusicPlayerProps)
    local scope = props.Scope

    return Frame {
        Scope = scope,

        Name = "MusicPlayer",

        LayoutOrder = props.LayoutOrder,

        AnchorPoint = props.AnchorPoint,
        Position = props.Position,
        Size = props.Size,

        AutomaticSize = Enum.AutomaticSize.XY,

        BackgroundTransparency = 1,

        Children = {
            ListLayout {
                Scope = scope,

                FillDirection = Enum.FillDirection.Vertical,

                HorizontalAlignment = Enum.HorizontalAlignment.Right,
                VerticalAlignment = Enum.VerticalAlignment.Top,

                Padding = UDim.new(0, 5),
            },

            TextLabel {
                Scope = scope,

                AutomaticSize = Enum.AutomaticSize.XY,

                Text = scope:Computed(function(use)
                    return `{use(props.Title)} [{formatTime(use(props.Progress))}]`
                end),

                TextSize = 16,

                StrokeThickness = 2,
            },

            Frame {
                Scope = scope,

                Size = UDim2.fromOffset(0, 30),

                AutomaticSize = Enum.AutomaticSize.X,

                BackgroundTransparency = 1,

                Children = {
                    ListLayout {
                        Scope = scope,

                        FillDirection = Enum.FillDirection.Horizontal,

                        HorizontalAlignment = Enum.HorizontalAlignment.Left,
                        VerticalAlignment = Enum.VerticalAlignment.Top,

                        Padding = UDim.new(0, 10),
                    },

                    IconButton {
                        Scope = scope,

                        Name = "PreviousButton",

                        Size = UDim2.fromScale(1, 1),

                        SizeConstraint = Enum.SizeConstraint.RelativeYY,

                        Icon = Icons.Back,

                        Activated = props.PreviousSong,
                    },

                    IconButton {
                        Scope = scope,

                        Name = "PlaybackButton",

                        Size = UDim2.fromScale(1, 1),

                        SizeConstraint = Enum.SizeConstraint.RelativeYY,

                        Icon = scope:Computed(function(use)
                            return if use(props.Playing) then Icons.Pause else Icons.Play
                        end),

                        Activated = props.TogglePlayback,
                    },

                    IconButton {
                        Scope = scope,

                        Name = "NextButton",

                        Size = UDim2.fromScale(1, 1),

                        SizeConstraint = Enum.SizeConstraint.RelativeYY,

                        Icon = Icons.Forward,

                        Activated = props.NextSong,
                    },
                }
            }
        }
    }
end

return MusicPlayer