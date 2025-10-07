type Map<K, V> = { [K]: V }

local function Count<K, V>(map: Map<K, V>): number
    local count = 0

    for _ in map do
        count += 1
    end

    return count
end

return Count