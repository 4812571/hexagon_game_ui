--!strict
--!native

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage.Common

local Flags = require(Common.Skins.Flags)
local Blocks = require(Common.Skins.Blocks)

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
    Grass = SkinInfo {
        Id = "Grass",
        Name = "Grass",
        ImageId = Blocks.Grass,
        Price = 2.5 * THOUSAND,
    },

    Wood = SkinInfo {
        Id = "Wood",
        Name = "Wood",
        ImageId = Blocks.Planks,
        Price = 3.0 * THOUSAND,
    },

    Stone = SkinInfo {
        Id = "Stone",
        Name = "Stone",
        ImageId = Blocks.Stone,
        Price = 3.5 * THOUSAND,
    },

    Brick = SkinInfo {
        Id = "Brick",
        Name = "Brick",
        ImageId = Blocks.BrownBricks,
        Price = 4.0 * THOUSAND,
    },

    Bedrock = SkinInfo {
        Id = "Bedrock",
        Name = "Bedrock",
        ImageId = Blocks.Bedrock,
        Price = 4.5 * THOUSAND,
    },

    Obsidian = SkinInfo {
        Id = "Obsidian",
        Name = "Obsidian",
        ImageId = Blocks.Obsidian,
        Price = 5.0 * THOUSAND,
    },

    Portal = SkinInfo {
        Id = "Portal",
        Name = "Portal",
        ImageId = Blocks.Portal,
        Price = 6.0 * THOUSAND,
    },

    Magma = SkinInfo {
        Id = "Magma",
        Name = "Magma",
        ImageId = Blocks.Magma,
        Price = 7.0 * THOUSAND,
    },

    Lava = SkinInfo {
        Id = "Lava",
        Name = "Lava",
        ImageId = Blocks.Lava,
        Price = 8.5 * THOUSAND,
    },

    GoldOre = SkinInfo {
        Id = "GoldOre",
        Name = "Gold Ore",
        ImageId = Blocks.GoldOre,
        Price = 10.0 * THOUSAND,
    },

    DiamondOre = SkinInfo {
        Id = "DiamondOre",
        Name = "Diamond Ore",
        ImageId = Blocks.DiamondOre,
        Price = 12.5 * THOUSAND,
    },

    Sculk = SkinInfo {
        Id = "Sculk",
        Name = "Sculk",
        ImageId = Blocks.Magic,
        Price = 13.5 * THOUSAND,
    },

    Diamonds = SkinInfo {
        Id = "Diamonds",
        Name = "Diamonds",
        ImageId = Blocks.Diamond,
        Price = 15.0 * THOUSAND,
    },

    Space = SkinInfo {
        Id = "Space",
        Name = "Space",
        ImageId = "http://www.roblox.com/asset/?id=1179217564",
        Price = 17.5 * THOUSAND,
    },

    Rainbow = SkinInfo {
        Id = "Rainbow",
        Name = "Rainbow",
        ImageId = "http://www.roblox.com/asset/?id=252684207",
        Price = 20.0 * THOUSAND,
    },

    MemeDog = SkinInfo {
        Id = "MemeDog",
        Name = "Meme Dog",
        ImageId = "http://www.roblox.com/asset/?id=9763545065",
        Price = 25.0 * THOUSAND,
    },

    MemeCat = SkinInfo {
        Id = "MemeCat",
        Name = "Meme Cat",
        ImageId = "http://www.roblox.com/asset/?id=12662853323",
        Price = 25.0 * THOUSAND,
    },

    StareCat = SkinInfo {
        Id = "StareCat",
        Name = "Stare Cat",
        ImageId = "http://www.roblox.com/asset/?id=12928844840",
        Price = 30.0 * THOUSAND,
    },

    StandCat = SkinInfo {
        Id = "StandCat",
        Name = "Stand Cat",
        ImageId = "http://www.roblox.com/asset/?id=9142678935",
        Price = 35.0 * THOUSAND,
    },

    BannanaCat = SkinInfo {
        Id = "BananaCat",
        Name = "Banana Cat",
        ImageId = "http://www.roblox.com/asset/?id=18842556765",
        Price = 40.0 * THOUSAND,
    },

    Backrooms = SkinInfo {
        Id = "Backrooms",
        Name = "Backrooms",
        ImageId = "http://www.roblox.com/asset/?id=13024422158",
        Price = 60.0 * THOUSAND,
    },

    Water = SkinInfo {
        Id = "Water",
        Name = "Water",
        ImageId = "http://www.roblox.com/asset/?id=81475937",
        Price = 80.0 * THOUSAND,
    },

    Sahur = SkinInfo {
        Id = "Sahur",
        Name = "Sahur",
        ImageId = "http://www.roblox.com/asset/?id=85462826391722",
        Price = 175.0 * THOUSAND,
    },

    Trallalero = SkinInfo {
        Id = "Trallalero",
        Name = "Trallalero",
        ImageId = "http://www.roblox.com/asset/?id=94623164590640",
        Price = 250.0 * THOUSAND,
    },

    Cappuccino = SkinInfo {
        Id = "Cappuccino",
        Name = "Cappuccino",
        ImageId = "http://www.roblox.com/asset/?id=127329475552981",
        Price = 350.0 * THOUSAND,
    },

    Robux = SkinInfo {
        Id = "Robux",
        Name = "Robux",
        ImageId = "http://www.roblox.com/asset/?id=11560341824",
        Price = 0.5 * MILLION,
    },

    Dollar = SkinInfo {
        Id = "Dollar",
        Name = "Dollar",
        ImageId = "http://www.roblox.com/asset/?id=18637664349",
        Price = 0.75 * MILLION,
    },

    Warning = SkinInfo {
        Id = "Warning",
        Name = "Warning",
        ImageId = "http://www.roblox.com/asset/?id=7205517910",
        Price = 1.0 * MILLION,
    },

    Cards = SkinInfo {
        Id = "Cards",
        Name = "Cards",
        ImageId = "http://www.roblox.com/asset/?id=11160772544",
        Price = 1.5 * MILLION,
    },

    Chess = SkinInfo {
        Id = "Chess",
        Name = "Chess",
        ImageId = "http://www.roblox.com/asset/?id=14356201620",
        Price = 2.0 * MILLION,
    },

    Squid = SkinInfo {
        Id = "Squid",
        Name = "Squid",
        ImageId = "http://www.roblox.com/asset/?id=14390921513",
        Price = 3.0 * MILLION,
    },

    Doge = SkinInfo {
        Id = "Doge",
        Name = "Doge",
        ImageId = "http://www.roblox.com/asset/?id=157767960",
        Price = 5.0 * MILLION,
    },

    Labubu = SkinInfo {
        Id = "Labubu",
        Name = "Labubu",
        ImageId = "http://www.roblox.com/asset/?id=135353780787681",
        Price = 10.0 * MILLION,
    },

    Troll = SkinInfo {
        Id = "Troll",
        Name = "Troll",
        ImageId = "http://www.roblox.com/asset/?id=8599330674",
        Price = 15.0 * MILLION,
    },

    SmileDog = SkinInfo {
        Id = "SmileDog",
        Name = "Smile Dog",
        ImageId = "http://www.roblox.com/asset/?id=133239599452033",
        Price = 20.0 * MILLION,
    },

    FluffyDog = SkinInfo {
        Id = "FluffyDog",
        Name = "Fluffy Dog",
        ImageId = "http://www.roblox.com/asset/?id=135334243758516",
        Price = 100.0 * MILLION,
    },

    DripDog = SkinInfo {
        Id = "DripDog",
        Name = "Drip Dog",
        ImageId = "http://www.roblox.com/asset/?id=10568517082",
        Price = 50.0 * MILLION,
    },

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
