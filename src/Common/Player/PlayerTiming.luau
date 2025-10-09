export type PlayerTiming = {
    Check: (instant: number) -> boolean,
}

local ALLOWED_LATENCY = 8

local function PlayerTiming(joinTime: number): PlayerTiming
    local lastInstant = joinTime

    local function Check(instant: number): boolean
        print(`Time {lastInstant} -> {instant}`)

        if instant < lastInstant then
            return false
        end

        if math.abs(workspace:GetServerTimeNow() - instant) > ALLOWED_LATENCY then
            return false
        end

        lastInstant = instant
        return true
    end

    local self: PlayerTiming = {
        Check = Check,
    }

    return self
end

return PlayerTiming