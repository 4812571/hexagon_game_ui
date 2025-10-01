local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)

local Frame = require(Client.Interface.Frame)
local ListLayout = require(Client.Interface.ListLayout)
local TextButton = require(Client.Interface.TextButton)

local ProgressBar = require(script.Parent.ProgressBar)

return function(target: Instance)
    local scope = Fusion.scoped(Fusion)

    local progress = scope:Value(1)
    local progressSmooth = scope:Spring(progress, 20)

    local instance = Frame {
        Scope = scope,

        BackgroundTransparency = 1,

        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(1, 1),

        Children = {
            scope:New "UIPadding" {
                PaddingBottom = UDim.new(0, 10),
            },

            Frame {
                Scope = scope,

                BackgroundTransparency = 1,

                AnchorPoint = Vector2.new(0.5, 1),
                Position = UDim2.fromScale(0.5, 1) - UDim2.fromOffset(0, 85),
                Size = UDim2.fromOffset(0, 75),

                AutomaticSize = Enum.AutomaticSize.X,

                Children = {
                    ListLayout {
                        Scope = scope,

                        FillDirection = Enum.FillDirection.Horizontal,

                        HorizontalAlignment = Enum.HorizontalAlignment.Center,
                        VerticalAlignment = Enum.VerticalAlignment.Center,

                        Padding = UDim.new(0, 15),
                    },

                    TextButton {
                        Scope = scope,

                        Size = UDim2.fromScale(0, 1),

                        AutomaticSize = Enum.AutomaticSize.X,

                        Text = "Randomize",

                        TextSize = 25,

                        BackgroundColor3 = Color3.fromRGB(250, 200, 0),

                        Activated = function()
                            progress:set(math.random())
                        end,
                    },

                    TextButton {
                        Scope = scope,

                        Size = UDim2.fromScale(0, 1),

                        AutomaticSize = Enum.AutomaticSize.X,

                        Text = "Fill",

                        TextSize = 25,

                        BackgroundColor3 = Color3.fromRGB(120, 230, 30),

                        Activated = function()
                            progress:set(1)
                        end,
                    },

                    TextButton {
                        Scope = scope,

                        Size = UDim2.fromScale(0, 1),

                        AutomaticSize = Enum.AutomaticSize.X,

                        Text = "Empty",

                        TextSize = 25,

                        BackgroundColor3 = Color3.fromRGB(230, 80, 30),

                        Activated = function()
                            progress:set(0)
                        end,
                    },
                }
            },

            ProgressBar {
                Scope = scope,

                BackgroundColor3 = Color3.fromRGB(83, 130, 201),

                Progress = progressSmooth,
                Text = scope:Computed(function(use)
                    return `{math.round(use(progressSmooth) * 100)}%`
                end),

                AnchorPoint = Vector2.new(0.5, 1),
                Position = UDim2.fromScale(0.5, 1),
                Size = UDim2.fromOffset(300, 65),
            },
        }
    }

    instance.Parent = target

    return function()
        scope:doCleanup()
    end
end