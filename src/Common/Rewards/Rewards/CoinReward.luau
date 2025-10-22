--!strict
--!native

export type CoinReward = {
    Type: "Coin",
    Amount: number,
}

local function CoinReward(amount: number): CoinReward
    local reward: CoinReward = {
        Type = "Coin",
        Amount = amount,
    }

    return reward
end

return CoinReward
