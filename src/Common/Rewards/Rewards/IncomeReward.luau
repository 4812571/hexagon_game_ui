export type IncomeReward = {
    Type: "Income",
    Percent: number,
}

local function IncomeReward(percent: number): IncomeReward
    local reward = {
        Type = "Income",
        Percent = percent,
    }

    return reward
end

return IncomeReward