--!strict
--!native

export type ReviveReward = {
    Type: "Revive",
    Amount: number,
}

local function ReviveReward(amount: number): ReviveReward
    local reward: ReviveReward = {
        Type = "Revive",
        Amount = amount,
    }

    return reward
end

return ReviveReward
