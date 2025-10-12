--!strict
--!native

export type BombConfig = {
    Cooldown: number,
    FuseTime: number,
    BlastRadius: number,
}

local BombsConfig = {
    Bomb = {
        Cooldown = 2,
        FuseTime = 5,
        BlastRadius = 4,
    },

    GoldBomb = {
        Cooldown = 3,
        FuseTime = 5,
        BlastRadius = 7,
    },

    Nuke = {
        Cooldown = 4,
        FuseTime = 5,
        BlastRadius = 12,
    },
}

return BombsConfig
