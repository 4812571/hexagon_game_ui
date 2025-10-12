--!strict
--!native

export type SpeedReward = {
    Type: "Speed",
    Percent: number,
}

local function SpeedReward(percent: number): SpeedReward
    local reward = {
        Type = "Speed",
        Percent = percent,
    }

    return reward
end

return SpeedReward
