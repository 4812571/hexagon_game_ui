--!strict
--!native
--!nolint LocalShadow

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)

local Text = require(Client.Interface.Text)
local InteractionFrame = require(Client.Interface.InteractionFrame)

type Scope<T> = Fusion.Scope<typeof(Fusion) & T>
type UsedAs<T> = Fusion.UsedAs<T>

type Components = {
    Text: typeof(Text),
    InteractionFrame: typeof(InteractionFrame),
}

type ClaimBannerProps = {
    Size: UsedAs<UDim2>?,
    Position: UsedAs<UDim2>?,
    AnchorPoint: UsedAs<Vector2>?,

    Color: UsedAs<Color3?>,
    OnClick: () -> (),
}

local function ClaimBanner<U>(scope: Scope<U>, props: ClaimBannerProps)
    local scope: Scope<Components> = scope:innerScope {
        Text = Text,
        InteractionFrame = InteractionFrame,
    }

    local guiState = scope:Value(Enum.GuiState.NonInteractable)

    local claimScale = scope:Computed(function(use)
        if use(guiState) == Enum.GuiState.Hover then
            return 1.1
        end

        if use(guiState) == Enum.GuiState.Press then
            return 0.9
        end

        return 1.0
    end)

    local claimColor = scope:Computed(function(use)
        if use(guiState) == Enum.GuiState.Hover then
            return use(props.Color):Lerp(Color3.new(0, 0, 0), 0.2)
        end

        return use(props.Color)
    end)

    return scope:InteractionFrame {
        Size = props.Size,
        Position = props.Position,
        AnchorPoint = props.AnchorPoint,

        BackgroundTransparency = 0.35,
        BackgroundColor3 = scope:Spring(claimColor, 32),

        Activated = props.OnClick,

        GuiStateChanged = function(state: Enum.GuiState)
            guiState:set(state)
        end,

        Children = {
            scope:New "UIStroke" {
                Thickness = 4,
                Color = Color3.fromRGB(0, 0, 0),
                LineJoinMode = Enum.LineJoinMode.Miter,
            },

            scope:Text {
                Size = UDim2.fromScale(1, 1),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Rotation = 0,

                BackgroundTransparency = 1,

                Text = "Claim!",
                TextSize = 25,
                StrokeSize = 3.0,

                Children = scope:New "UIScale" {
                    Scale = scope:Spring(claimScale, 32)
                },
            },
        },
    }
end

return ClaimBanner