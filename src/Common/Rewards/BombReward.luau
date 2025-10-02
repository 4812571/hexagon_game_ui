export type BombType = "Bomb" | "GoldBomb" | "Nuke"

export type BombReward = {
    Type: "Bomb",
    BombType: BombType,
    Amount: number,
}

local function BombReward(bombType: BombType, amount: number): BombReward
    local reward = {
        Type = "Bomb",
        BombType = bombType,
        Amount = amount,
    }

    return reward
end

return BombReward