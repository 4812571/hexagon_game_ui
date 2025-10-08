export type SpinReward = {
    Type: "Spin",
    Amount: number,
}

local function SpinReward(amount: number): SpinReward
    local reward = {
        Type = "Spin",
        Amount = amount,
    }

    return reward
end

return SpinReward