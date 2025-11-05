--!strict
--!native
--!nolint LocalShadow

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)
local Children = Fusion.Children

type Scope<T> = Fusion.Scope<typeof(Fusion) & T>

local Icon = require(Client.Interface.Icon)
local Text = require(Client.Interface.Text)
local ProgressBar = require(Client.Interface.ProgressBar)

type Components = {
    Icon: typeof(Icon),
    Text: typeof(Text),
    ProgressBar: typeof(ProgressBar),
}

type RebirthBarProps = {
    Size: Fusion.UsedAs<UDim2>?,
    Position: Fusion.UsedAs<UDim2>?,
    AnchorPoint: Fusion.UsedAs<Vector2>?,

    LayoutOrder: Fusion.UsedAs<number>?,

    Icon: Fusion.UsedAs<string>,
    Text: Fusion.UsedAs<string>,

    Progress: Fusion.UsedAs<number>,
    RequiredProgress: Fusion.UsedAs<number>,
}


local function CommaFormatNumber(number: number): string
    local str = tostring(number)
    local result = ""
    local count = 0

    for i = #str, 1, -1 do
        result = str:sub(i, i) .. result
        count += 1
        if count % 3 == 0 and i > 1 then
            result = "," .. result
        end
    end

    return result
end

local function RebirthBar<U>(scope: Scope<U>, props: RebirthBarProps)
    local scope: Scope<Components> = scope:innerScope {
        Icon = Icon,
        Text = Text,
        ProgressBar = ProgressBar,
    }

    return scope:New "Frame" {
        Size = props.Size,
        Position = props.Position,
        AnchorPoint = props.AnchorPoint,

        LayoutOrder = props.LayoutOrder,

        BackgroundTransparency = 1,

        [Children] = {
            scope:New "UIListLayout" {
                FillDirection = Enum.FillDirection.Horizontal,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,

                HorizontalFlex = Enum.UIFlexAlignment.Fill,

                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 12),
            },

            scope:Icon {
                Icon = props.Icon,
                Size = UDim2.fromScale(1, 1),
            },

            scope:New "Frame" {
                Size = UDim2.fromScale(1, 1),
                BackgroundTransparency = 1,

                [Children] = {
                    scope:New "UIListLayout" {
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        FillDirection = Enum.FillDirection.Vertical,
                        VerticalAlignment = Enum.VerticalAlignment.Center,
                        HorizontalAlignment = Enum.HorizontalAlignment.Center,

                        Padding = UDim.new(0, 8),
                    },

                    scope:Text {
                        LayoutOrder = 1,
                        Size = UDim2.fromScale(1, 0.5),
                        AutomaticSize = Enum.AutomaticSize.Y,
                        TextSize = 28,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        TextYAlignment = Enum.TextYAlignment.Bottom,
                        
                        Text = props.Text,
                        StrokeSize = 3.0,
                    },

                    scope:ProgressBar {
                        LayoutOrder = 2,

                        Size = UDim2.fromScale(1, 0.5),
                        Progress = props.Progress,
                        RequiredProgress = props.RequiredProgress,
                        
                        BarColor = Color3.fromRGB(72, 255, 0),
                        BackgroundColor = Color3.new(0, 0, 0),

                        Text = scope:Computed(function(use)
                            return `{CommaFormatNumber(use(props.Progress))} / {CommaFormatNumber(use(props.RequiredProgress))}`
                        end),

                        TextSize = 32,

                        BarAlpha = scope:Computed(function(use)
                            return math.clamp((use(props.Progress) :: number) / (use(props.RequiredProgress) :: number), 0, 1)
                        end),
                    },
                }
            },
        }
    }
end

return RebirthBar