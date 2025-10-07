local function Counter(): () -> number
    local currentValue = 0

    local function Count(): number
        currentValue += 1
        return currentValue
    end

    return Count
end

return Counter