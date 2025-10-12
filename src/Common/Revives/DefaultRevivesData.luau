--!strict
--!native

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage.Common

local RevivesData = require(Common.Revives.RevivesData)
type RevivesData = RevivesData.RevivesData

local DefaultRevivesData: RevivesData = {
    Revives = 3,
}

return DefaultRevivesData
