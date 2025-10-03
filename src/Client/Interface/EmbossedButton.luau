local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- local SoundService = game:GetService("SoundService")

local Packages = ReplicatedStorage.Packages
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)

local peek = Fusion.peek

local EmbossedFrame = require(Client.Interface.EmbossedFrame)
local ListLayout = require(Client.Interface.ListLayout)
local ButtonFrame = require(Client.Interface.ButtonFrame)

local BOTTOM_PADDING = 5
local HOVER_PADDING = 10

export type EmbossedButtonProps = {
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

    CornerRadius: Fusion.UsedAs<UDim>?,

    Children: Fusion.UsedAs<Fusion.Child>?,

    Activated: () -> ()?,

    Pressed: () -> ()?,
    Released: () -> ()?,

    StateChanged: (guiState: Enum.GuiState) -> ()?,
}

local function EmbossedButton(props: EmbossedButtonProps)
    local scope = props.Scope

    local isSelected = scope:Value(false)

    local guiState = scope:Value(Enum.GuiState.NonInteractable)

    local backgroundColor = props.BackgroundColor3 or Color3.fromRGB(255, 255, 255)

    local bottomPadding = scope:Computed(function(use)
        local state = use(guiState)

        if state == Enum.GuiState.Press then
            return 0
        end

        if state == Enum.GuiState.Hover then
            return BOTTOM_PADDING
        end

        return HOVER_PADDING
    end)

    local bottomPaddingSmooth = scope:Spring(bottomPadding, 70, 1)

    local wasActive = false

    scope:Observer(guiState):onBind(function()
        local state = peek(guiState)

        if props.StateChanged then
            props.StateChanged(state)
        end

        if not wasActive and state == Enum.GuiState.Hover then
            -- SoundService:PlayLocalSound(ReplicatedStorage.Assets.Sounds.ButtonHover)
        end

        if state == Enum.GuiState.Press then
            wasActive = true

            -- SoundService:PlayLocalSound(ReplicatedStorage.Assets.Sounds.ButtonActivate)

            if props.Pressed then
                props.Pressed()
            end

            return
        end

        if wasActive then
            wasActive = false

            -- SoundService:PlayLocalSound(ReplicatedStorage.Assets.Sounds.ButtonRelease)

            if props.Released then
                props.Released()
            end
        end
    end)

    return ButtonFrame {
        Scope = scope,

        Name = props.Name or "Button",

        LayoutOrder = props.LayoutOrder,

        BackgroundTransparency = 1,

        AnchorPoint = props.AnchorPoint,
        Position = props.Position,
        Size = props.Size,

        AutomaticSize = props.AutomaticSize,

        StateChanged = function(state: Enum.GuiState)
            guiState:set(state)
        end,
        SelectedChaged = function(selected: boolean)
            isSelected:set(selected)
        end,

        Activated = props.Activated,

        Children = {
            scope:New "UIPadding" {
                PaddingTop = scope:Computed(function(use)
                    return UDim.new(0, HOVER_PADDING - math.round(use(bottomPaddingSmooth)))
                end),
            },

            ListLayout {
                Scope = scope,

                FillDirection = Enum.FillDirection.Vertical,

                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                VerticalAlignment = Enum.VerticalAlignment.Center,

                HorizontalFlex = Enum.UIFlexAlignment.Fill,
                VerticalFlex = Enum.UIFlexAlignment.Fill,
            },

            EmbossedFrame {
                Scope = scope,

                BackgroundColor3 = backgroundColor,
                BackgroundGradient = props.BackgroundGradient,
                BackgroundTransparency = props.BackgroundTransparency,

                AutomaticSize = props.AutomaticSize,

                PaddingBottom = scope:Computed(function(use)
                    return UDim.new(0, math.round(use(bottomPaddingSmooth)))
                end),

                Children = {
                    ListLayout {
                        Scope = scope,

                        FillDirection = Enum.FillDirection.Vertical,

                        HorizontalAlignment = Enum.HorizontalAlignment.Center,
                        VerticalAlignment = Enum.VerticalAlignment.Top,

                        VerticalFlex = Enum.UIFlexAlignment.Fill,
                        HorizontalFlex = Enum.UIFlexAlignment.Fill,
                    },

                    Children = props.Children
                },
            }
        },
    }
end

return EmbossedButton