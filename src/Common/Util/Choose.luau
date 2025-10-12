--!strict
--!native

local function Choose<T>(random: Random, collection: {T})
    local collectionSize = #collection

    if collectionSize == 0 then
        return nil
    end

    local index = random:NextInteger(1, collectionSize)
    return collection[index]
end

return Choose
