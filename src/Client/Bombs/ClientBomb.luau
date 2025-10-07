local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)
local peek = Fusion.peek
type Scope = Fusion.Scope<typeof(Fusion)>

local Clock = require(Common.Util.Clock)

local ColorShift = require(Client.Bombs.ColorShift)

local TAU = math.pi * 2

local FLASH_FREQUENCY = 1
local FLASH_FACTOR = 1.25

local FLASH_COLOR = Color3.fromRGB(255, 0, 0)
local MAX_ALPHA = 0.35

local FALL_ACCELERATION = 50
local INITIAL_VELOCITY = 5

local LANDING_HEIGHT = 0.5

local function Parts(instance: Instance): {BasePart}
    local parts = {}

    for _, descendant in instance:GetDescendants() do
        if descendant:IsA("BasePart") then
            table.insert(parts, descendant)
        end
    end

    return parts
end

local function UnitSin(t: number): number
    return (math.sin(t) + 1) / 2
end

export type ClientBomb = {
    Model: Model,
}

local function ClientBomb(scope: Scope, bombModel: Model, startPosition: Vector3)
    local driverTime = Clock(scope)

    local flashEnabledTime = scope:Value(nil)
    local fallingStartTime = workspace:GetServerTimeNow()

    local alpha = scope:Computed(function(use)
        if not use(flashEnabledTime) then
            return 0
        end

        local elapsed = use(driverTime) - use(flashEnabledTime)

        return UnitSin((elapsed ^ FLASH_FACTOR) * TAU * FLASH_FREQUENCY) * MAX_ALPHA
    end)

    for _, part in Parts(bombModel) do
        ColorShift(scope, part, FLASH_COLOR, alpha)
    end

    local elapsedFallingTime = scope:Computed(function(use)
        return use(driverTime) - fallingStartTime
    end)

    local startHeight = bombModel:GetPivot().Y

    local height = scope:Computed(function(use)
        return math.max(startHeight - 0.5 * FALL_ACCELERATION * use(elapsedFallingTime) ^ 2 - INITIAL_VELOCITY * use(elapsedFallingTime), LANDING_HEIGHT)
    end)

    scope:Observer(height):onBind(function()
        bombModel:PivotTo(CFrame.new(startPosition.X, peek(height), startPosition.Z))
    end)

    scope:Observer(height):onChange(function()
        if peek(flashEnabledTime) then
            return
        end

        if peek(height) > LANDING_HEIGHT then
            return
        end

        flashEnabledTime:set(workspace:GetServerTimeNow())
    end)

    local self = {
        Model = bombModel,
    }

    return self
end

return ClientBomb