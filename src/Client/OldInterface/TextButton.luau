local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)

local TextLabel = require(Client.Interface.TextLabel)
local EmbossedButton = require(Client.Interface.EmbossedButton)

export type TextButtonProps = {
    Scope: Fusion.Scope<typeof(Fusion)>,

    Name: Fusion.UsedAs<string>?,

    LayoutOrder: Fusion.UsedAs<number>?,

    BackgroundColor3: Fusion.UsedAs<Color3>?,
    BackgroundTransparency: Fusion.UsedAs<number>?,
    BackgroundGradient: Fusion.UsedAs<ColorSequence>?,

    AnchorPoint: Fusion.UsedAs<Vector2>?,
    Position: Fusion.UsedAs<UDim2>?,
    Size: Fusion.UsedAs<UDim2>?,

    AutomaticSize: Fusion.UsedAs<Enum.AutomaticSize>?,

    Text: Fusion.UsedAs<string>,

    TextColor3: Fusion.UsedAs<Color3>?,

    TextSize: Fusion.UsedAs<number>?,

    TextXAlignment: Fusion.UsedAs<Enum.TextXAlignment>?,
    TextYAlignment: Fusion.UsedAs<Enum.TextYAlignment>?,

    RichText: Fusion.UsedAs<boolean>?,

    Activated: () -> ()?,

    Pressed: () -> ()?,
    Released: () -> ()?,

    StateChanged: (guiState: Enum.GuiState) -> ()?,
}

local function TextButton(props: TextButtonProps)
    local scope = props.Scope

    return EmbossedButton {
        Scope = scope,

        Name = props.Name,

        LayoutOrder = props.LayoutOrder,

        BackgroundColor3 = props.BackgroundColor3,
        BackgroundTransparency = props.BackgroundTransparency,
        BackgroundGradient = props.BackgroundGradient,

        AnchorPoint = props.AnchorPoint,
        Position = props.Position,
        Size = props.Size,

        AutomaticSize = props.AutomaticSize,

        Activated = props.Activated,

        Pressed = props.Pressed,
        Released = props.Released,

        StateChanged = props.StateChanged,

        Children = {
            scope:New "UIPadding" {
                PaddingTop = UDim.new(0, 10),
                PaddingBottom = UDim.new(0, 10),
                PaddingLeft = UDim.new(0, 20),
                PaddingRight = UDim.new(0, 20),
            },

            TextLabel {
                Scope = scope,

                AutomaticSize = props.AutomaticSize,

                Text = props.Text,

                TextColor3 = props.TextColor3,

                TextSize = props.TextSize,

                TextXAlignment = props.TextXAlignment or Enum.TextXAlignment.Center,
                TextYAlignment = props.TextYAlignment or Enum.TextYAlignment.Center,

                RichText = props.RichText,
            }
        }
    }
end

return TextButton