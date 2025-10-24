--!strict
--!native
--!nolint LocalShadow

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)
local Children = Fusion.Children

local BombCard = require(Client.Bombs.BombCard)

type Scope<T> = Fusion.Scope<typeof(Fusion) & T>

export type Components = {
    BombCard: typeof(BombCard),
}

export type BombEntry = {
    Icon: string,
    Count: Fusion.UsedAs<number>,
    Cooldown: Fusion.UsedAs<number>,
    State: Fusion.Value<Enum.GuiState>,
    Activated: () -> (),

    CardTransparency: Fusion.UsedAs<number>?,
    CardGradient: Fusion.Child?,
}

export type BombWindowProps = {
    Visible: Fusion.UsedAs<boolean>?,
    Scale: Fusion.UsedAs<number>?,

    Position: Fusion.UsedAs<UDim2>?,
    AnchorPoint: Fusion.UsedAs<Vector2>?,
    Bombs: Fusion.UsedAs<{BombEntry}>,
}

local function BombWindow<U>(scope: Scope<U>, props: BombWindowProps)
    local scope = scope:innerScope {
        BombCard = BombCard,
    }

    return scope:New "Frame" {
        Size = UDim2.fromOffset(600, 200),
        Position = props.Position,
        AnchorPoint = props.AnchorPoint,

        Visible = props.Visible,

        BackgroundTransparency = 1,

        [Children] = {
            scope:New "UIScale" {
                Scale = props.Scale,
            },

            scope:New "UIListLayout" {
                SortOrder = Enum.SortOrder.LayoutOrder,
                FillDirection = Enum.FillDirection.Horizontal,

                VerticalAlignment = Enum.VerticalAlignment.Center,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
            },

            scope:ForPairs(props.Bombs, function(use, scope: Scope<Components>, index: number, bomb: BombEntry)
                local scale = scope:Computed(function(use)
                    if use(bomb.State) == Enum.GuiState.Hover then
                        return 1.1
                    end

                    if use(bomb.State) == Enum.GuiState.Press then
                        return 0.9
                    end

                    return 1.0
                end)

                return index, scope:BombCard {
                    BombIcon = bomb.Icon,

                    Count = bomb.Count,
                    Cooldown = bomb.Cooldown,

                    Size = UDim2.fromOffset(180, 180),
                    AnchorPoint = Vector2.new(0.5, 0.5),

                    Transparency = bomb.CardTransparency,
                    Gradient = bomb.CardGradient,

                    Activated = bomb.Activated,

                    GuiStateChanged = function(state: Enum.GuiState)
                        bomb.State:set(state)
                    end,

                    Scale = scope:Spring(scale, 30),
                }
            end)
        } :: {Fusion.Child},
    }
end

return BombWindow