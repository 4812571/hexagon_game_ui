--!strict
--!native
--!nolint LocalShadow

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)
local Children = Fusion.Children

local Icon = require(Client.Interface.Icon)

type Scope<T> = Fusion.Scope<typeof(Fusion) & T>

type Components = {
    Icon: typeof(Icon),
}

type TopbarParticleProps = {
    Position: Fusion.UsedAs<UDim2>,
    Size: Fusion.UsedAs<UDim2>,
    Scale: Fusion.UsedAs<number>,

    Icon: Fusion.UsedAs<string>,
    IconScale: Fusion.UsedAs<number>?,
}

local function TopbarParticle<U>(scope: Scope<U>, props: TopbarParticleProps)
    local scope: Scope<Components> = scope:innerScope {
        Icon = Icon,
    }
    
    return scope:New "Frame" {
        Size = props.Size,
        Position = props.Position,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,

        ZIndex = -1,
        
        [Children] = {
            scope:New "UIScale" {
                Scale = props.Scale,
            },

            scope:Icon {
                Size = UDim2.fromScale(1, 1),
                Position = UDim2.fromScale(0.5, 0.5),
                AnchorPoint = Vector2.new(0.5, 0.5),

                Icon = props.Icon,
                IconScale = props.IconScale,
            },
        }
    }
end

return TopbarParticle
    