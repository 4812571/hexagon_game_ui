local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

local Packages = ReplicatedStorage.Packages
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)

local peek = Fusion.peek

local Children = Fusion.Children
local Out = Fusion.Out
local OnEvent = Fusion.OnEvent

local ListLayout = require(Client.Interface.ListLayout)

export type ButtonFrameProps = {
    Scope: Fusion.Scope<typeof(Fusion)>,

    Name: Fusion.UsedAs<string>?,

    LayoutOrder: Fusion.UsedAs<number>?,

    BackgroundColor3: Fusion.UsedAs<Color3>?,
    BackgroundTransparency: Fusion.UsedAs<number>?,

    AnchorPoint: Fusion.UsedAs<Vector2>?,
    Position: Fusion.UsedAs<UDim2>?,
    Size: Fusion.UsedAs<UDim2>?,

    SizeConstraint: Fusion.UsedAs<Enum.SizeConstraint>?,

    AutomaticSize: Fusion.UsedAs<Enum.AutomaticSize>?,

    Children: Fusion.UsedAs<Fusion.Child>?,

    Activated: () -> ()?,

    Pressed: () -> ()?,
    Released: () -> ()?,

    StateChanged: (guiState: Enum.GuiState) -> ()?,
    SelectedChanged: (selected: boolean) -> ()?,
}

local function ButtonFrame(props: ButtonFrameProps)
    local scope = props.Scope

    local isSelected = scope:Value(false)

    local guiState = scope:Value(Enum.GuiState.NonInteractable)

    local wasActive = false

    if props.SelectedChanged then
        scope:Observer(isSelected):onBind(function()
            props.SelectedChanged(peek(isSelected))
        end)
    end

    scope:Observer(guiState):onBind(function()
        local state = peek(guiState)

        if props.StateChanged then
            props.StateChanged(state)
        end

        if not wasActive and state == Enum.GuiState.Hover then
            -- SoundService:PlayLocalSound(ReplicatedStorage.Assets.Sounds.ButtonFrameHover)
        end

        if state == Enum.GuiState.Press then
            wasActive = true

            -- SoundService:PlayLocalSound(ReplicatedStorage.Assets.Sounds.ButtonFrameActivate)

            if props.Pressed then
                props.Pressed()
            end

            return
        end

        if wasActive then
            wasActive = false

            --- SoundService:PlayLocalSound(ReplicatedStorage.Assets.Sounds.ButtonFrameRelease)

            if props.Released then
                props.Released()
            end
        end
    end)

    return scope:New "ImageButton" {
        Name = props.Name or "ButtonFrame",

        LayoutOrder = props.LayoutOrder,

        BackgroundColor3 = props.BackgroundColor3,
        BackgroundTransparency = props.BackgroundTransparency,

        AnchorPoint = props.AnchorPoint or Vector2.new(0, 0),
        Position = props.Position or UDim2.fromScale(0, 0),
        Size = props.Size or UDim2.fromScale(0, 0),

        SizeConstraint = props.SizeConstraint,

        AutomaticSize = props.AutomaticSize,

        AutoButtonColor = false,

        [Out "GuiState"] = guiState,
        [Out "Selected"] = isSelected,

        [OnEvent "Activated"] = props.Activated,

        [Children] = {
            ListLayout {
                Scope = scope,

                FillDirection = Enum.FillDirection.Vertical,

                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                VerticalAlignment = Enum.VerticalAlignment.Center,

                HorizontalFlex = Enum.UIFlexAlignment.Fill,
                VerticalFlex = Enum.UIFlexAlignment.Fill,
            },

            Children = props.Children
        },
    }
end

return ButtonFrame