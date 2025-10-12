--!strict
--!native

export type Choice<T> = {
    Weight: number,
    Value: T,
}

local function WeightedChoice<T>(random: Random, values: {Choice<T>}): T
    local totalWeight = 0

    for _, value in values do
        totalWeight += value.Weight
    end

    local selectionPoint = random:NextNumber() * totalWeight

    local currentWeight = 0

    for _, value in values do
        currentWeight += value.Weight

        if selectionPoint <= currentWeight then
            return value.Value
        end
    end

    error("[unreachable] Failed to select a weighted choice")
end

return WeightedChoice
