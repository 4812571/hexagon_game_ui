local RebirthBombs = {
    Bombs = 6,
    GoldBombs = 4,
    Nukes = 2,
}

local RebirthRewards = {
    SpeedPercent = 15,
    IncomePercent = 20,
    Bombs = RebirthBombs,
}

local RebirthCosts = {
    Level = 100,
    Coins = 1_000_000,
}

local RebirthConfig = {
    Rewards = RebirthRewards,
    Costs = RebirthCosts,
}

return RebirthConfig