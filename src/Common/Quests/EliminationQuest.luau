export type EliminationQuest = {
    Type: "Elimination",
    Amount: number,
}

local function EliminationQuest(amount: number): EliminationQuest
    local request = {
        Type = "Elimination",
        Amount = amount,
    }

    return request
end

return EliminationQuest