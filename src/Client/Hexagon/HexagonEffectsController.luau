local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages

local Fusion = require(Packages.Fusion)
type Scope = Fusion.Scope<typeof(Fusion)>

local NetworkClient = require(ReplicatedStorage.NetworkClient)

local BASE_FOV = 70
local BOUNCE_VELOCITY = 200
local SPRING_SPEED = 7.5

type HexagonEffectsController = {
    Shake: (intensity: number) -> (),
    Start: () -> (),
}

local function HexagonEffectsController(scope: Scope)
    local cameraSpring = scope:Spring(scope:Value(BASE_FOV), SPRING_SPEED)

    local function FovShake(intensity: number)
        print(`[HexagonEffectsController] Shaking FOV with intensity {intensity}`)
        cameraSpring:addVelocity(intensity)
    end

    local function Start()
        NetworkClient.Hexagon.ClaimEffect.On(function(exteriorTiles: number, interiorTiles: number)
            local totalTiles = exteriorTiles + interiorTiles

            if totalTiles <= 0 then
                return
            end

            FovShake(BOUNCE_VELOCITY)

            if interiorTiles > 0 then
                -- play major sound
            else
                -- play minor sound
            end
        end)

        scope:Hydrate(workspace.CurrentCamera) {
            FieldOfView = cameraSpring,
        }
    end

    local self = {
        Shake = FovShake,
        Start = Start,
    }

    return self
end

return HexagonEffectsController