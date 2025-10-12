--!strict
--!native

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage.Common

local Axial = require(Common.Hexagon.Axial)
export type Axial = Axial.Axial

local function Key(axial: Axial): string
	return tostring(axial.Q) .. "-" .. tostring(axial.R)
end

local directions = {
    Axial(1, 0), Axial(1, -1), Axial(0, -1),
    Axial(-1, 0), Axial(-1, 1), Axial(0, 1),
}

local function Neighbors(axial: Axial): {Axial}
	local neighbors = {}

	for _, dir in directions do
		table.insert(neighbors, Axial(axial.Q + dir.Q, axial.R + dir.R))
	end

	return neighbors
end

local function AxialToWorld(axial: Axial): Vector3
    local x = 1.5 * axial.Q
    local z = (math.sqrt(3) / 2) * axial.Q + math.sqrt(3) * axial.R
    return Vector3.new(x, 0, z)
end

local function WorldToAxial(pos: Vector3): Axial
    local q = (2/3) * pos.X
    local r = (-1/3) * pos.X + (math.sqrt(3) / 3) * pos.Z
    return Axial(q, r)
end

local function NearestAxial(axial: Axial): Axial
	local q = axial.Q
	local r = axial.R
	local s = -q - r

	local rq = math.floor(q + 0.5)
	local rr = math.floor(r + 0.5)
	local rs = math.floor(s + 0.5)

	local dq = math.abs(rq - q)
	local dr = math.abs(rr - r)
	local ds = math.abs(rs - s)

	if dq > dr and dq > ds then
		return Axial(-rr - rs, rr)
    elseif dr > ds then
        return Axial(rq, -rq - rs)
    else
        return Axial(rq, rr)
    end
end

local function WorldToNearestAxial(pos: Vector3): Axial
	local axial = WorldToAxial(pos)
	return NearestAxial(axial)
end

local function Hexagon(radius: number): {Axial}
	local hexes = {}

	for q = -radius, radius do
		local r1 = math.max(-radius, -q - radius)
		local r2 = math.min(radius, -q + radius)
		for r = r1, r2 do
			table.insert(hexes, Axial(q, r))
		end
	end

	return hexes
end

local function Add(a: Axial, b: Axial): Axial
    return Axial(a.Q + b.Q, a.R + b.R)
end

local function Ring(radius: number): {Axial}
    if radius == 0 then
        return {Axial(0, 0)}
    end

    local results = {}
    -- starting hex: go `radius` steps southwest
    local hex = Axial(-radius, radius)

    for side = 1, 6 do
        for step = 1, radius do
            table.insert(results, hex)
            hex = Add(hex, directions[side])
        end
    end

    return results
end

local function IsInBounds(axial: Axial, radius: number): boolean
    local q = axial.Q
    local r = axial.R
    local s = -q - r
    local distance = (math.abs(q) + math.abs(r) + math.abs(s)) / 2
    return distance <= radius
end

local function ClampToBounds(axial: Axial, radius: number): Axial
    -- convert to cube coords
    local q = axial.Q
    local r = axial.R
    local s = -q - r

    -- first snap to nearest cube coordinate
    local rq = math.floor(q + 0.5)
    local rr = math.floor(r + 0.5)
    local rs = math.floor(s + 0.5)

    -- cube distance from origin
    local dist = (math.abs(rq) + math.abs(rr) + math.abs(rs)) / 2
    if dist <= radius then
        return Axial(rq, rr)
    end

    -- clamp: scale down to lie exactly on the boundary
    local scale = radius / dist
    local cq = rq * scale
    local cr = rr * scale

    -- re-round to nearest cube coordinate
    return NearestAxial(Axial(cq, cr))
end


local HexagonUtil = {
    Axial = Axial,
	Key = Key,

    Add = Add,

	Neighbors = Neighbors,

    AxialToWorld = AxialToWorld,
    WorldToAxial = WorldToAxial,
    NearestAxial = NearestAxial,
    WorldToNearestAxial = WorldToNearestAxial,

	Hexagon = Hexagon,
    Ring = Ring,

	IsInBounds = IsInBounds,
	ClampToBounds = ClampToBounds,
}

return HexagonUtil
