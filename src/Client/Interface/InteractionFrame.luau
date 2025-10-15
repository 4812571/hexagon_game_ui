--!strict
--!native

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages

local Fusion = require(Packages.Fusion)
local peek = Fusion.peek
local Out = Fusion.Out
local OnEvent = Fusion.OnEvent
local Children = Fusion.Children

type Scope<T> = Fusion.Scope<T>
type UsedAs<T> = Fusion.UsedAs<T>

export type InteractionFrameProps = {
    Name: UsedAs<string>?,

    Position: UsedAs<UDim2>?,
    Size: UsedAs<UDim2>?,
    AnchorPoint: UsedAs<Vector2>?,
    Rotation: UsedAs<number>?,

    LayoutOrder: UsedAs<number>?,

    BackgroundColor3: UsedAs<Color3>?,
    BackgroundTransparency: UsedAs<number>?,

    Activated: () -> ()?,
    GuiStateChanged: (Enum.GuiState) -> ()?,

    Children: UsedAs<Fusion.Child>?,
}

local function InteractionFrame<U>(scope: Scope<typeof(Fusion) & U>, props: InteractionFrameProps)
    local guiState = scope:Value(Enum.GuiState.NonInteractable)

    scope:Observer(guiState):onBind(function()
        if props.GuiStateChanged then
            props.GuiStateChanged(peek(guiState))
        end
    end)

    return scope:New "ImageButton" {
        Name = props.Name,

        Position = props.Position,
        Size = props.Size,
        AnchorPoint = props.AnchorPoint,
        Rotation = props.Rotation,
        
        LayoutOrder = props.LayoutOrder,

        BackgroundColor3 = props.BackgroundColor3,
        BackgroundTransparency = props.BackgroundTransparency,

        [OnEvent "Activated"] = props.Activated,
        [Out "GuiState"] = guiState,

        [Children] = props.Children,
    }
end

return InteractionFrame
