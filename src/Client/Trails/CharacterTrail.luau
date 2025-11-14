local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common

local Fusion = require(Packages.Fusion)
local AttributeOut = Fusion.AttributeOut
local Children = Fusion.Children

local Trails = require(Common.Trails.Trails)

type Scope<T> = Fusion.Scope<typeof(Fusion) & T>

export type CharacterTrail = true

local TRAIL_WIDTH = 1.5

local function CharacterTrail<U>(scope: Scope<U>, character: Instance): CharacterTrail
    if not character:IsA("Model") then
        error("Character must be a Model")
    end

    local trailName: Fusion.Value<string?> = scope:Value(nil)

    local attachment0 = scope:New "Attachment" {
        Name = "TrailAttachment0",
        Position = Vector3.new(-TRAIL_WIDTH / 2, 0, 0),
    }

    local attachment1 = scope:New "Attachment" {
        Name = "TrailAttachment1",
        Position = Vector3.new(TRAIL_WIDTH / 2, 0, 0),
    }

    local trail = scope:Computed(function(use)
        local trailName = use(trailName)

        if not trailName then
            return {}
        end

        local trailEntry: Trails.TrailEntry? = Trails[trailName]

        if not trailEntry then
            return {}
        end

        return scope:New "Trail" {
            Lifetime = 1,
            
            Attachment0 = attachment0,
            Attachment1 = attachment1,
            Color = trailEntry.Color,
        }
    end)

    scope:Hydrate(character) {
        [AttributeOut "TrailName"] = trailName,
    
        [Children] = {
            attachment0,
            attachment1,
            trail,
        }
    }

    return true
end

return CharacterTrail