--!strict
--!nolint LocalShadow

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)

type Scope<T> = Fusion.Scope<typeof(Fusion) & T>
type UsedAs<T> = Fusion.UsedAs<T>

local Icons = require(Common.Icons)

local Icon = require(Client.Interface.Icon)
local InteractionFrame = require(Client.Interface.InteractionFrame)

export type CloseButtonProps = {
    Size: UsedAs<UDim2>?,
    Position: UsedAs<UDim2>?,
    AnchorPoint: UsedAs<Vector2>?,

    Activated: () -> ()?,
}

local HOVER_SCALE = 1.1
local PRESS_SCALE = 0.95

local ROTATION_AMOUNT = 20
local PRESS_ROTATION = 10

local function CloseButton<U>(scope: Scope<U>, props: CloseButtonProps)
    local scope = scope:innerScope {
        Icon = Icon,
        InteractionFrame = InteractionFrame,
    }

    local guiState = scope:Value(Enum.GuiState.NonInteractable)

    local scale = scope:Computed(function(use)
        if use(guiState) == Enum.GuiState.Hover then
            return HOVER_SCALE
        end

        if use(guiState) == Enum.GuiState.Press then
            return PRESS_SCALE
        end

        return 1
    end)

    local rotation = scope:Computed(function(use)
        if use(guiState) == Enum.GuiState.Hover then
            return ROTATION_AMOUNT
        end

        if use(guiState) == Enum.GuiState.Press then
            return PRESS_ROTATION
        end

        return 0
    end)

    return scope:InteractionFrame {
        Size = props.Size,
        Position = props.Position,
        AnchorPoint = props.AnchorPoint,

        BackgroundTransparency = 1,

        GuiStateChanged = function(state: Enum.GuiState)
            guiState:set(state)
        end,

        Activated = props.Activated,

        Children = {
            scope:Icon {
                Icon = Icons.Close,
                Size = UDim2.fromScale(1, 1),
                Rotation = scope:Spring(rotation, 60),
            },

            scope:New "UIScale" {
                Scale = scope:Spring(scale, 60),
            },
        },
    }
end

return CloseButton