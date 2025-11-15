--!strict
--!native
--!nolint LocalShadow

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)
local peek = Fusion.peek

local InteractionFrame = require(Client.Interface.InteractionFrame)

export type Scaling = {
    Idle: number,
    Hover: number,
    Press: number,
}

type Scope<T> = Fusion.Scope<typeof(Fusion) & T>

export type Components = {
    InteractionFrame: typeof(InteractionFrame),
}

export type ButtonFrameProps = {
    Name: Fusion.UsedAs<string>?,

    Position: Fusion.UsedAs<UDim2>?,
    Size: Fusion.UsedAs<UDim2>?,
    AnchorPoint: Fusion.UsedAs<Vector2>?,
    Rotation: Fusion.UsedAs<number>?,

    LayoutOrder: Fusion.UsedAs<number>?,
    SizeConstraint: Fusion.UsedAs<Enum.SizeConstraint>?,

    BackgroundColor3: Fusion.UsedAs<Color3>?,
    BackgroundTransparency: Fusion.UsedAs<number>?,

    Activated: () -> ()?,
    GuiStateChanged: (Enum.GuiState) -> ()?,

    Scaling: Scaling,

    Children: Fusion.UsedAs<Fusion.Child>?,
}

local function ButtonFrame<U>(scope: Scope<U>, props: ButtonFrameProps)
    local scope: Scope<Components> = scope:innerScope {
        InteractionFrame = InteractionFrame,
    }

    local guiState = scope:Value(Enum.GuiState.NonInteractable)

    if props.GuiStateChanged then
        scope:Observer(guiState):onBind(function()
            props.GuiStateChanged(peek(guiState))
        end)
    end

    local scale = scope:Computed(function(use)
        if use(guiState) == Enum.GuiState.Press then
            return props.Scaling.Press
        end

        if use(guiState) == Enum.GuiState.Hover then
            return props.Scaling.Hover
        end

        return props.Scaling.Idle
    end)

    return scope:InteractionFrame {
        Name = props.Name,

        Position = props.Position,
        Size = props.Size,
        AnchorPoint = props.AnchorPoint,
        Rotation = props.Rotation,

        LayoutOrder = props.LayoutOrder,
        SizeConstraint = props.SizeConstraint,

        BackgroundColor3 = props.BackgroundColor3,
        BackgroundTransparency = props.BackgroundTransparency,

        Activated = props.Activated,

        GuiStateChanged = function(state: Enum.GuiState)
            guiState:set(state)
        end,

        Children = {
            scope:New "UIScale" {
                Scale = scope:Spring(scale, 35),
            },

            props.Children :: Fusion.Child,
        } :: {Fusion.Child},
    }
end

return ButtonFrame