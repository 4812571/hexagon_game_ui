--!strict
--!native

export type SpinReward = {
    Type: "Spin",
    Amount: number,
}

local function SpinReward(amount: number): SpinReward
    local reward: SpinReward = {
        Type = "Spin",
        Amount = amount,
    }

    return reward
end

return SpinReward
