export type Sequence<T> = {
    Next: () -> T,
}

local function Sequence<T>(elements: {T}): Sequence<T>
    local index = 0
    
    local function Next(): T
        index += 1
        return elements[(index % #elements) + 1]
    end

    local self: Sequence<T> = {
        Next = Next,
    }

    return self
end

return Sequence