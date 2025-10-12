--!strict
--!native

local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages

local Fusion = require(Packages.Fusion)
type Scope = Fusion.Scope<typeof(Fusion)>

local function Clone(scope: Scope, instance: Instance): Instance
    local clone = instance:Clone()
    table.insert(scope, clone)
    return clone
end

export type CharacterCrown = {
    Character: Model,
    Crown: Model,
}

local function CharacterCrown(scope: Scope, character: Instance): CharacterCrown
    if not character:IsA("Model") then
        error("Character must be a Model")
    end

    local crown = Clone(scope, ReplicatedStorage.Crown)
    crown.Parent = character

    table.insert(scope, RunService.RenderStepped:Connect(function()
        crown:PivotTo(character:GetPivot() * CFrame.new(0, 5, 0))
    end))

    local self: CharacterCrown = {
        Character = character,
        Crown = crown,
    }

    return self
end

return CharacterCrown
