--!strict
--!native
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage.Common

local TrailIcons = require(Common.TrailIcons)

export type Currency = "Coins" | "Robux"

export type TrailPrice = {
    Amount: number,
    Currency: Currency,
}

local function Price(amount: number, currency: Currency): TrailPrice
    local price = {
        Amount = amount,
        Currency = currency,
    }

    return price
end

export type TrailEntry = {
    Id: string,
    Color: ColorSequence,
    ThemeColor: Color3,
    Icon: string,
    Price: TrailPrice,
}

local Colors = {
    Red = ColorSequence.new(Color3.new(1, 0, 0)),
    Yellow = ColorSequence.new(Color3.new(1, 1, 0)),
    Blue = ColorSequence.new(Color3.new(0, 0, 1)),
    Green = ColorSequence.new(Color3.new(0, 1, 0)),
    Purple = ColorSequence.new(Color3.new(0.5, 0, 0.5)),
    Pink = ColorSequence.new(Color3.new(0.945098, 0.458824, 0.701961)),
    White = ColorSequence.new(Color3.new(1, 1, 1)),
    Black = ColorSequence.new(Color3.new(0, 0, 0)),
    
    Hacker = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 0, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 100, 0)),
    }),

    Fire = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 165, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 0)),
    }),

    Blossom = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 192, 203)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 105, 180)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 20, 147)),
    }),

    Frost = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(173, 216, 230)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(135, 206, 235)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 191, 255)),
    }),

    Electric = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(55, 0, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 221, 28)),
    }),

    Rainbow = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 127, 0)),
        ColorSequenceKeypoint.new(0.33, Color3.fromRGB(255, 255, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 0)),
        ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
        ColorSequenceKeypoint.new(0.83, Color3.fromRGB(75, 0, 130)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(148, 0, 211)),
    }),

    Banana = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 102)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(204, 204, 0)),
    }),
}

local Trails = {
    Red = {
        Id = "Red",
        Color = Colors.Red,
        ThemeColor = Color3.new(1, 0, 0),
        Icon = TrailIcons.Red,
        Price = Price(500, "Coins"),
    },

    Yellow = {
        Id = "Yellow",
        Color = Colors.Yellow,
        ThemeColor = Color3.new(1, 1, 0),
        Icon = TrailIcons.Yellow,
        Price = Price(1000, "Coins"),
    },

    Blue = {
        Id = "Blue",
        Color = Colors.Blue,
        ThemeColor = Color3.new(0, 0, 1),
        Icon = TrailIcons.Blue,
        Price = Price(1500, "Coins"),
    },

    Green = {
        Id = "Green",
        Color = Colors.Green,
        ThemeColor = Color3.new(0, 1, 0),
        Icon = TrailIcons.Green,
        Price = Price(2000, "Coins"),
    },

    Purple = {
        Id = "Purple",
        Color = Colors.Purple,
        ThemeColor = Color3.new(0.5, 0, 0.5),
        Icon = TrailIcons.Purple,
        Price = Price(5000, "Coins"),
    },

    Pink = {
        Id = "Pink",
        Color = Colors.Pink,
        ThemeColor = Color3.new(1, 0.4, 0.7),
        Icon = TrailIcons.Pink,
        Price = Price(10_000, "Coins"),
    },

    Hacker = {
        Id = "Hacker",
        Color = Colors.Hacker,
        ThemeColor = Color3.new(0, 0, 0),
        Icon = TrailIcons.Green,
        Price = Price(200_000, "Coins"),
    },

    Fire = {
        Id = "Fire",
        Color = Colors.Fire,
        ThemeColor = Color3.new(1, 0.5, 0),
        Icon = TrailIcons.Orange,
        Price = Price(400_000, "Coins"),
    },

    Blossom = {
        Id = "Blossom",
        Color = Colors.Blossom,
        ThemeColor = Color3.new(1, 0.2, 0.6),
        Icon = TrailIcons.Magenta,
        Price = Price(1_000_000, "Coins"),
    },

    Frost = {
        Id = "Frost",
        Color = Colors.Frost,
        ThemeColor = Color3.new(0.5, 0.75, 1),
        Icon = TrailIcons.Cyan,
        Price = Price(2_000_000, "Coins"),
    },

    Electric = {
        Id = "Electric",
        Color = Colors.Electric,
        ThemeColor = Color3.new(0, 1, 1),
        Icon = TrailIcons.Yellow,
        Price = Price(49, "Robux"),
    },

    Rainbow = {
        Id = "Rainbow",
        Color = Colors.Rainbow,
        ThemeColor = Color3.new(1, 1, 1),
        Icon = TrailIcons.Cyan,
        Price = Price(49, "Robux"),
    },

    Banana = {
        Id = "Banana",
        Color = Colors.Banana,
        ThemeColor = Color3.new(1, 1, 0),
        Icon = TrailIcons.Yellow,
        Price = Price(49, "Robux"),
    },

}

return Trails
