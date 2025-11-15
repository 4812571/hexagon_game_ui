--!strict
--!native

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages

local Fusion = require(Packages.Fusion)

local ButtonFrame = require(script.Parent.ButtonFrame)

return function(target: Instance)
    local scope = Fusion.scoped(Fusion, {
        ButtonFrame = ButtonFrame,
    })

    local guiState = scope:Value(Enum.GuiState.NonInteractable)

    local color = scope:Computed(function(use)
        local state = use(guiState)

        if state == Enum.GuiState.NonInteractable then
            return Color3.new(0, 0, 0)
        end
        
        if state == Enum.GuiState.Idle then
            return Color3.new(1, 1, 1)
        end

        if state == Enum.GuiState.Hover then
            return Color3.new(1, 0, 0)
        end

        if state == Enum.GuiState.Press then
            return Color3.new(0, 1, 0)
        end

        error("Unknown GuiState: " .. tostring(state))
    end)

    local ButtonFrame = scope:ButtonFrame {
        Name = "ButtonFrame",

        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(200, 200),
        AnchorPoint = Vector2.new(0.5, 0.5),

        BackgroundColor3 = color,

        GuiStateChanged = function(state)
            guiState:set(state)
        end,

        Scaling = {
            Idle = 1,
            Hover = 1.1,
            Press = 0.9,
        },

        Children = scope:New "UICorner" {
            CornerRadius = UDim.new(0, 300),
        }
    }

    ButtonFrame.Parent = target

    return function()
        scope:doCleanup()
    end
end
