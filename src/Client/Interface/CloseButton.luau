local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Client = ReplicatedStorage.Client

local Frame = require(ReplicatedStorage.Client.Interface.Frame)
local Fusion = require(Packages.Fusion)

local Children = Fusion.Children

local Icons = require(Common.Icons)

local ButtonFrame = require(Client.Interface.ButtonFrame)

export type CloseButtonProps = {
    Scope: Fusion.Scope<typeof(Fusion)>,

    AnchorPoint: Fusion.UsedAs<Vector2>?,
    Position: Fusion.UsedAs<UDim2>?,
    Size: Fusion.UsedAs<UDim2>?,

    Activated: () -> ()?,
}

local function CloseButton(props: CloseButtonProps)
    local scope = props.Scope

    local guiState = scope:Value(Enum.GuiState.NonInteractable)

    local scale = scope:Computed(function(use)
        local state = use(guiState)

        if state == Enum.GuiState.Hover then
            return 1.1
        end

        if state == Enum.GuiState.Press then
            return 0.95
        end

        return 1
    end)

    local scaleSmooth = scope:Spring(scale, 60)

    return ButtonFrame {
        Scope = scope,

        Name = "CloseButton",

        BackgroundTransparency = 1,

        AnchorPoint = props.AnchorPoint,
        Position = props.Position,
        Size = props.Size,

        StateChanged = function(state: Enum.GuiState)
            guiState:set(state)
        end,

        Activated = props.Activated,

        Children = Frame {
            Scope = scope,

            BackgroundTransparency = 1,

            Children = scope:New "ImageLabel" {
                Name = "CloseIcon",

                BackgroundTransparency = 1,

                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(1, 1),

                Image = Icons.Close,

                [Children] = scope:New "UIScale" {
                    Scale = scaleSmooth,
                }
            }
        },
    }
end

return CloseButton