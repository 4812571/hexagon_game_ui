local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)

local Children = Fusion.Children

local Frame = require(Client.Interface.Frame)

export type IconProps = {
    Scope: Fusion.Scope<typeof(Fusion)>,

    Icon: Fusion.UsedAs<string>,
    IconScale: Fusion.UsedAs<number>?,
}

local function Icon(props: IconProps)
    local scope = props.Scope

    return Frame {
        Scope = scope,

        Size = UDim2.fromOffset(30, 30),

        BackgroundTransparency = 1,

        Children = Frame {
            Scope = scope,

            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1.25, 1.25),

            BackgroundTransparency = 1,

            Children = {
                scope:New "UIScale" {
                    Scale = props.IconScale
                },

                scope:New "ImageLabel" {
                    Name = "Shadow",

                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.fromScale(0.5, 0.5) + UDim2.fromOffset(3, 3),
                    Size = UDim2.fromScale(1, 1),

                    BackgroundTransparency = 1,

                    Image = props.Icon,
                    ImageColor3 = Color3.fromRGB(0, 0, 0),
                    ImageTransparency = 0.75,
                },

                scope:New "ImageLabel" {
                    Name = "Icon",

                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.fromScale(0.5, 0.5),
                    Size = UDim2.fromScale(1, 1),

                    BackgroundTransparency = 1,

                    Image = props.Icon,
                },
            }
        }
    }
end

return Icon