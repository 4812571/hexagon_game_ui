--!strict
--!native

export type Axial = {
    Q: number,
    R: number,
}

local function Axial(q: number, r: number): Axial
    local axial = {
        Q = q,
        R = r,
    }

    return axial
end

return Axial
