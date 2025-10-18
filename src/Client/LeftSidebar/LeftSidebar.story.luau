--!strict
--!native

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages

local Fusion = require(Packages.Fusion)

local LeftSidebar = require(script.Parent.LeftSidebar)

return function(target: Instance)
    local scope = Fusion.scoped(Fusion, {
        LeftSidebar = LeftSidebar,
    })

    local random = Random.new()
    
    local instance = scope:LeftSidebar {
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),

        Revives = random:NextInteger(0, 10),
    
        LevelButton = {
            IsNew = random:NextNumber() < 0.5,
            
            Activated = function()
                print("Level button activated!")
            end,
        },

        QuestsButton = {
            IsNew = random:NextNumber() < 0.5,
            
            Activated = function()
                print("Quests button activated!")
            end,
        },

        RebirthButton = {
            IsNew = random:NextNumber() < 0.5,
            
            Activated = function()
                print("Rebirth button activated!")
            end,
        },

        TrailsButton = {
            IsNew = random:NextNumber() < 0.5,
            
            Activated = function()
                print("Trails button activated!")
            end,
        },

        SkinsButton = {
            IsNew = random:NextNumber() < 0.5,
            
            Activated = function()
                print("Skins button activated!")
            end,
        },

        TrollButton = {
            IsNew = random:NextNumber() < 0.5,
            
            Activated = function()
                print("Troll button activated!")
            end,
        },
    }

    instance.Parent = target

    return function()
        scope:doCleanup()
    end
end