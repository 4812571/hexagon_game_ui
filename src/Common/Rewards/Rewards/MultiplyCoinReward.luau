--!strict
--!native

export type MultiplyCoinReward = {
    Type: "MultiplyCoin",
    Multiplier: number,
}

local function MultiplyCoinReward(multiplier: number): MultiplyCoinReward
    local reward = {
        Type = "MultiplyCoin",
        Multiplier = multiplier,
    }

    return reward
end

return MultiplyCoinReward
