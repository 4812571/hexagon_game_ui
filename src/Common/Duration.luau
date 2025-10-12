--!strict
--!native

local SECOND = 1
local MINUTE = 60 * SECOND
local HOUR = 60 * MINUTE
local DAY = 24 * HOUR
local WEEK = 7 * DAY
local MONTH = 30 * DAY
local YEAR = 365 * DAY

local Duration = {
    Second = SECOND,
    Minute = MINUTE,
    Hour = HOUR,
    Day = DAY,
    Week = WEEK,
    Month = MONTH,
    Year = YEAR,
}

return Duration
