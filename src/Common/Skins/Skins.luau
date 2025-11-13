--!strict
--!native

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage.Common

local Flags = require(Common.Skins.Flags)

export type SkinInfo = {
    Id: string,
    Name: string,
    ImageId: string,
    Price: number,
}

local THOUSAND = 1000
local MILLION = 1000 * THOUSAND

local function SkinInfo(skinInfo: SkinInfo): SkinInfo
    return table.freeze(skinInfo)
end

local FLAG_PRICE = 1500

local Skins = {
    FlagUS = SkinInfo {
        Id = "FlagUS",
        Name = "USA",
        ImageId = Flags.US,
        Price = FLAG_PRICE,
    },

    FlagCN = SkinInfo {
        Id = "FlagCN",
        Name = "China",
        ImageId = Flags.CN,
        Price = FLAG_PRICE,
    },

    FlagGB = SkinInfo {
        Id = "FlagGB",
        Name = "UK",
        ImageId = Flags.GB,
        Price = FLAG_PRICE,
    },

    FlagFR = SkinInfo {
        Id = "FlagFR",
        Name = "France",
        ImageId = Flags.FR,
        Price = FLAG_PRICE,
    },

    FlagDE = SkinInfo {
        Id = "FlagDE",
        Name = "Germany",
        ImageId = Flags.DE,
        Price = FLAG_PRICE,
    },

    FlagRU = SkinInfo {
        Id = "FlagRU",
        Name = "Russia",
        ImageId = Flags.RU,
        Price = FLAG_PRICE,
    },

    FlagIN = SkinInfo {
        Id = "FlagIN",
        Name = "India",
        ImageId = Flags.IN,
        Price = FLAG_PRICE,
    },

    FlagJP = SkinInfo {
        Id = "FlagJP",
        Name = "Japan",
        ImageId = Flags.JP,
        Price = FLAG_PRICE,
    },

    FlagIT = SkinInfo {
        Id = "FlagIT",
        Name = "Italy",
        ImageId = Flags.IT,
        Price = FLAG_PRICE,
    },

    FlagES = SkinInfo {
        Id = "FlagES",
        Name = "Spain",
        ImageId = Flags.ES,
        Price = FLAG_PRICE,
    },

    FlagCA = SkinInfo {
        Id = "FlagCA",
        Name = "Canada",
        ImageId = Flags.CA,
        Price = FLAG_PRICE,
    },

    FlagBR = SkinInfo {
        Id = "FlagBR",
        Name = "Brazil",
        ImageId = Flags.BR,
        Price = FLAG_PRICE,
    },

    FlagAU = SkinInfo {
        Id = "FlagAU",
        Name = "Australia",
        ImageId = Flags.AU,
        Price = FLAG_PRICE,
    },

    FlagMX = SkinInfo {
        Id = "FlagMX",
        Name = "Mexico",
        ImageId = Flags.MX,
        Price = FLAG_PRICE,
    },

    FlagKR = SkinInfo {
        Id = "FlagKR",
        Name = "South Korea",
        ImageId = Flags.KR,
        Price = FLAG_PRICE,
    },

    FlagNL = SkinInfo {
        Id = "FlagNL",
        Name = "Netherlands",
        ImageId = Flags.NL,
        Price = FLAG_PRICE,
    },

    FlagTR = SkinInfo {
        Id = "FlagTR",
        Name = "Turkey",
        ImageId = Flags.TR,
        Price = FLAG_PRICE,
    },

    FlagSA = SkinInfo {
        Id = "FlagSA",
        Name = "Saudi Arabia",
        ImageId = Flags.SA,
        Price = FLAG_PRICE,
    },

    FlagCH = SkinInfo {
        Id = "FlagCH",
        Name = "Switzerland",
        ImageId = Flags.CH,
        Price = FLAG_PRICE,
    },

    FlagAR = SkinInfo {
        Id = "FlagAR",
        Name = "Argentina",
        ImageId = Flags.AR,
        Price = FLAG_PRICE,
    },

    FlagPL = SkinInfo {
        Id = "FlagPL",
        Name = "Poland",
        ImageId = Flags.PL,
        Price = FLAG_PRICE,
    },

    FlagID = SkinInfo {
        Id = "FlagID",
        Name = "Indonesia",
        ImageId = Flags.ID,
        Price = FLAG_PRICE,
    },

    FlagSE = SkinInfo {
        Id = "FlagSE",
        Name = "Sweden",
        ImageId = Flags.SE,
        Price = FLAG_PRICE,
    },

    FlagBE = SkinInfo {
        Id = "FlagBE",
        Name = "Belgium",
        ImageId = Flags.BE,
        Price = FLAG_PRICE,
    },

    FlagAT = SkinInfo {
        Id = "FlagAT",
        Name = "Austria",
        ImageId = Flags.AT,
        Price = FLAG_PRICE,
    },

    FlagEG = SkinInfo {
        Id = "FlagEG",
        Name = "Egypt",
        ImageId = Flags.EG,
        Price = FLAG_PRICE,
    },

    FlagIR = SkinInfo {
        Id = "FlagIR",
        Name = "Iran",
        ImageId = Flags.IR,
        Price = FLAG_PRICE,
    },

    FlagIL = SkinInfo {
        Id = "FlagIL",
        Name = "Israel",
        ImageId = Flags.IL,
        Price = FLAG_PRICE,
    },

    FlagGR = SkinInfo {
        Id = "FlagGR",
        Name = "Greece",
        ImageId = Flags.GR,
        Price = FLAG_PRICE,
    },

    FlagPT = SkinInfo {
        Id = "FlagPT",
        Name = "Portugal",
        ImageId = Flags.PT,
        Price = FLAG_PRICE,
    },

    FlagNO = SkinInfo {
        Id = "FlagNO",
        Name = "Norway",
        ImageId = Flags.NO,
        Price = FLAG_PRICE,
    },

    FlagDK = SkinInfo {
        Id = "FlagDK",
        Name = "Denmark",
        ImageId = Flags.DK,
        Price = FLAG_PRICE,
    },

    FlagZA = SkinInfo {
        Id = "FlagZA",
        Name = "South Africa",
        ImageId = Flags.ZA,
        Price = FLAG_PRICE,
    },

    FlagTH = SkinInfo {
        Id = "FlagTH",
        Name = "Thailand",
        ImageId = Flags.TH,
        Price = FLAG_PRICE,
    },

    FlagAE = SkinInfo {
        Id = "FlagAE",
        Name = "UAE",
        ImageId = Flags.AE,
        Price = FLAG_PRICE,
    },

    FlagSG = SkinInfo {
        Id = "FlagSG",
        Name = "Singapore",
        ImageId = Flags.SG,
        Price = FLAG_PRICE,
    },

    FlagIE = SkinInfo {
        Id = "FlagIE",
        Name = "Ireland",
        ImageId = Flags.IE,
        Price = FLAG_PRICE,
    },

    FlagFI = SkinInfo {
        Id = "FlagFI",
        Name = "Finland",
        ImageId = Flags.FI,
        Price = FLAG_PRICE,
    },

    FlagCL = SkinInfo {
        Id = "FlagCL",
        Name = "Chile",
        ImageId = Flags.CL,
        Price = FLAG_PRICE,
    },

    FlagNG = SkinInfo {
        Id = "FlagNG",
        Name = "Nigeria",
        ImageId = Flags.NG,
        Price = FLAG_PRICE,
    },

    FlagPK = SkinInfo {
        Id = "FlagPK",
        Name = "Pakistan",
        ImageId = Flags.PK,
        Price = FLAG_PRICE,
    },

    FlagVN = SkinInfo {
        Id = "FlagVN",
        Name = "Vietnam",
        ImageId = Flags.VN,
        Price = FLAG_PRICE,
    },

    FlagCZ = SkinInfo {
        Id = "FlagCZ",
        Name = "Czech Republic",
        ImageId = Flags.CZ,
        Price = FLAG_PRICE,
    },

    FlagNZ = SkinInfo {
        Id = "FlagNZ",
        Name = "New Zealand",
        ImageId = Flags.NZ,
        Price = FLAG_PRICE,
    },

    FlagPH = SkinInfo {
        Id = "FlagPH",
        Name = "Philippines",
        ImageId = Flags.PH,
        Price = FLAG_PRICE,
    },

    FlagCO = SkinInfo {
        Id = "FlagCO",
        Name = "Colombia",
        ImageId = Flags.CO,
        Price = FLAG_PRICE,
    },

    FlagMY = SkinInfo {
        Id = "FlagMY",
        Name = "Malaysia",
        ImageId = Flags.MY,
        Price = FLAG_PRICE,
    },

    FlagPE = SkinInfo {
        Id = "FlagPE",
        Name = "Peru",
        ImageId = Flags.PE,
        Price = FLAG_PRICE,
    },

    FlagUA = SkinInfo {
        Id = "FlagUA",
        Name = "Ukraine",
        ImageId = Flags.UA,
        Price = FLAG_PRICE,
    },

    FlagRO = SkinInfo {
        Id = "FlagRO",
        Name = "Romania",
        ImageId = Flags.RO,
        Price = FLAG_PRICE,
    },
}

return Skins
