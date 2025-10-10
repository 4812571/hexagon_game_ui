local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)

local ButtonFrame = require(Client.Interface.ButtonFrame)
local Icon = require(Client.Interface.Icon)

export type IconButtonProps = {
    Scope: Fusion.Scope<typeof(Fusion)>,

    Name: Fusion.UsedAs<string>?,

    AnchorPoint: Fusion.UsedAs<Vector2>?,
    Position: Fusion.UsedAs<UDim2>?,
    Size: Fusion.UsedAs<UDim2>?,

    SizeConstraint: Fusion.UsedAs<Enum.SizeConstraint>?,

    Icon: Fusion.UsedAs<string>,
    IconScale: Fusion.UsedAs<number>?,

    Activated: () -> ()?,
}

local function IconButton(props: IconButtonProps)
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

        Name = props.Name or "IconButton",

        AnchorPoint = props.AnchorPoint,
        Position = props.Position,
        Size = props.Size,

        SizeConstraint = props.SizeConstraint,

        BackgroundTransparency = 1,

        StateChanged = function(state: Enum.GuiState)
            guiState:set(state)
        end,

        Activated = props.Activated,

        Children = Icon {
            Scope = scope,

            Icon = props.Icon,
            IconScale = scope:Computed(function(use)
                return use(scaleSmooth) * (use(props.IconScale) or 1)
            end),
        }
    }
end

return IconButton