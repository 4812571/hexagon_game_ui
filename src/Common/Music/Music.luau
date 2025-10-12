--!strict
--!native

export type Music = {
    Name: string,
    Link: string,
}

local function MusicEntry(name: string, link: string): Music
    local music = {
        Name = name,
        Link = link,
    }

    return music
end

local Music = {
    GotMe = MusicEntry("Got Me", "rbxassetid://9038571012"),
    YouAndMe = MusicEntry("You & Me", "rbxassetid://1841296740"),
    Escape = MusicEntry("Running Wild", "rbxassetid://1842104602"),
    Braziliana = MusicEntry("Braziliana", "rbxassetid://1840302441"),
    Happy = MusicEntry("Happy", "rbxassetid://9045802411"),
    Horizons = MusicEntry("Horizons", "rbxassetid://7028518546"),
    Expedition = MusicEntry("Expedition", "rbxassetid://1841769275"),
    CrabRave = MusicEntry("Crab Rave", "rbxassetid://5410086218"),
}

return Music
