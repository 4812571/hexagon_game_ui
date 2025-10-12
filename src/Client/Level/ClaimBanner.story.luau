--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages

local Fusion = require(Packages.Fusion)

local ClaimBanner = require(script.Parent.ClaimBanner)

return function(target: Instance)
    local scope = Fusion.scoped(Fusion, {
        ClaimBanner = ClaimBanner,
    })

    local banner = scope:ClaimBanner {
        Size = UDim2.fromOffset(300, 100),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),

        Color = Color3.fromRGB(28, 151, 233),

        OnClick = function()
            print("Claim Banner Clicked!")
        end,
    }

    banner.Parent = target

    return function()
        scope:doCleanup()
    end
end