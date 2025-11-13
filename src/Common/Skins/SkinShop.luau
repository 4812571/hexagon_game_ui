--!strict
--!native

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage.Common

local Skins = require(Common.Skins.Skins)
export type SkinInfo = Skins.SkinInfo

local Various: { SkinInfo } = {
    
}

local Flags: { SkinInfo } = {
    Skins.FlagUS,
    Skins.FlagGB,
    Skins.FlagCN,
    Skins.FlagFR,
    Skins.FlagDE,
    Skins.FlagRU,
    Skins.FlagIN,
    Skins.FlagJP,
    Skins.FlagIT,
    Skins.FlagES,
    Skins.FlagCA,
    Skins.FlagBR,
    Skins.FlagAU,
    Skins.FlagMX,
    Skins.FlagKR,
    Skins.FlagNL,
    Skins.FlagTR,
    Skins.FlagSA,
    Skins.FlagCH,
    Skins.FlagAR,
    Skins.FlagPL,
    Skins.FlagID,
    Skins.FlagSE,
    Skins.FlagBE,
    Skins.FlagAT,
    Skins.FlagEG,
    Skins.FlagIR,
    Skins.FlagIL,
    Skins.FlagGR,
    Skins.FlagPT,
    Skins.FlagNO,
    Skins.FlagDK,
    Skins.FlagZA,
    Skins.FlagTH,
    Skins.FlagAE,
    Skins.FlagSG,
    Skins.FlagIE,
    Skins.FlagFI,
    Skins.FlagCL,
    Skins.FlagNG,
    Skins.FlagPK,
    Skins.FlagVN,
    Skins.FlagCZ,
    Skins.FlagNZ,
    Skins.FlagPH,
    Skins.FlagCO,
    Skins.FlagMY,
    Skins.FlagPE,
    Skins.FlagUA,
    Skins.FlagRO,
}

local SkinShop = {
    Various = Various,
    Flags = Flags,
}

return SkinShop
