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
    Price: TrailPrice,
}

local function TrailEntry(id: string, color: ColorSequence, price: TrailPrice): TrailEntry
    local shopEntry = {
        Id = id,
        Color = color,
        Price = price,
    }

    return shopEntry
end

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
    Red = TrailEntry("Red", Colors.Red, Price(500, "Coins")),
    Yellow = TrailEntry("Yellow", Colors.Yellow, Price(1000, "Coins")),
    Blue = TrailEntry("Blue", Colors.Blue, Price(1500, "Coins")),
    Green = TrailEntry("Green", Colors.Green, Price(2000, "Coins")),
    Purple = TrailEntry("Purple", Colors.Purple, Price(5000, "Coins")),
    Pink = TrailEntry("Pink", Colors.Pink, Price(10_000, "Coins")),
    White = TrailEntry("White", Colors.White, Price(25_000, "Coins")),
    Black = TrailEntry("Black", Colors.Black, Price(50_000, "Coins")),
    Hacker = TrailEntry("Hacker", Colors.Hacker, Price(200_000, "Coins")),
    Fire = TrailEntry("Fire", Colors.Fire, Price(400_000, "Coins")),
    Blossom = TrailEntry("Blossom", Colors.Blossom, Price(1_000_000, "Coins")),
    Frost = TrailEntry("Frost", Colors.Frost, Price(2_000_000, "Coins")),
    Electric =  TrailEntry("Electric", Colors.Electric, Price(49, "Robux")),
    Rainbow = TrailEntry("Rainbow", Colors.Rainbow, Price(49, "Robux")),
    Banana = TrailEntry("Banana", Colors.Banana, Price(49, "Robux")),
}

return Trails