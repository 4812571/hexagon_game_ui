local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContextActionService = game:GetService("ContextActionService")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)
local peek = Fusion.peek
type Scope = Fusion.Scope<typeof(Fusion)>

local HexagonUtil = require(Common.Hexagon.HexagonUtil)
local HexagonConfig = require(Common.Hexagon.HexagonConfig)
type Axial = HexagonUtil.Axial

local BombsConfig = require(Common.Bombs.BombsConfig)

local NetworkClient = require(ReplicatedStorage.NetworkClient)

local ClientBomb = require(Client.Bombs.ClientBomb)
type ClientBomb = ClientBomb.ClientBomb

local ClientPlayer = require(Client.Player.ClientPlayer)
type ClientPlayer = ClientPlayer.ClientPlayer

local BombTemplate = ReplicatedStorage.Bombs.Bomb
local GoldBombTemplate = ReplicatedStorage.Bombs.GoldBomb
local NukeTemplate = ReplicatedStorage.Bombs.Nuke

local BOMB_HEIGHT = 50

type BombType = "Bomb" | "GoldBomb" | "Nuke"

local function Clone(scope: Scope, instance: Instance): Instance
    local clone = instance:Clone()
    table.insert(scope, clone)
    return clone
end

local function BombModel(scope: Scope, bombType: BombType)
    if bombType == "Bomb" then
        return Clone(scope, BombTemplate)
    end

    if bombType == "GoldBomb" then
        return Clone(scope, GoldBombTemplate)
    end

    if bombType == "Nuke" then
        return Clone(scope, NukeTemplate)
    end

    error("Invalid bomb type: " .. bombType)
end

type BombEntry = {
    Scope: Scope,
    Bomb: ClientBomb,
}

export type BombController = {
    Start: () -> (),
}

local function BombController(scope: Scope, player: ClientPlayer)
    local bombs: {[number]: BombEntry} = {}
    
    local nextBombTime = scope:Value(0)
    local nextGoldBombTime = scope:Value(0)
    local nextNukeTime = scope:Value(0)

    local function OnBombDeployed(bombType: BombType, position: Axial, index: number)
        local scope = scope:innerScope()
        
        local model = BombModel(scope, bombType)
        local startPosition = HexagonUtil.AxialToWorld(position) * HexagonConfig.HexagonSize + Vector3.yAxis * BOMB_HEIGHT
        model:PivotTo(CFrame.new(startPosition))
        model.Parent = workspace

        local bomb = ClientBomb(scope, model, startPosition)

        bombs[index] = {
            Scope = scope,
            Bomb = bomb,
        }
    end

    local function OnBombExploded(index: number)
        local entry = bombs[index]

        if not entry then
            warn(`No bomb found with index {index}`)
            return
        end

        entry.Scope:doCleanup()
        bombs[index] = nil
    end

    local function Start()
        NetworkClient.Bombs.BombDeployed.On(OnBombDeployed)
        NetworkClient.Bombs.BombExploded.On(OnBombExploded)
    end

    -- 1 to deploy bomb
    ContextActionService:BindAction("DeployBomb", function(_, state)
        if state == Enum.UserInputState.Begin then
            local currentTime = workspace:GetServerTimeNow()

            if currentTime < peek(nextBombTime) then
                return
            end

            if peek(player.Bombs.Bombs) <= 0 then
                return
            end

            nextBombTime:set(currentTime + BombsConfig.Bomb.Cooldown)
            NetworkClient.Bombs.Use.Invoke("Bomb", workspace:GetServerTimeNow())
            player.Bombs.Bombs:set(peek(player.Bombs.Bombs) - 1)
        end
    end, false, Enum.KeyCode.One)

    -- 2 to deploy gold bomb
    ContextActionService:BindAction("DeployGoldBomb", function(_, state)
        if state == Enum.UserInputState.Begin then
            local currentTime = workspace:GetServerTimeNow()

            if currentTime < peek(nextGoldBombTime) then
                return
            end

            if peek(player.Bombs.GoldBombs) <= 0 then
                return
            end

            nextGoldBombTime:set(currentTime + BombsConfig.GoldBomb.Cooldown)
            NetworkClient.Bombs.Use.Invoke("GoldBomb", workspace:GetServerTimeNow())
            player.Bombs.GoldBombs:set(peek(player.Bombs.GoldBombs) - 1)
        end
    end, false, Enum.KeyCode.Two)

    -- 3 to deploy nuke
    ContextActionService:BindAction("DeployNuke", function(_, state)
        if state == Enum.UserInputState.Begin then
            local currentTime = workspace:GetServerTimeNow()

            if currentTime < peek(nextNukeTime) then
                return
            end

            if peek(player.Bombs.Nukes) <= 0 then
                return
            end

            nextNukeTime:set(currentTime + BombsConfig.Nuke.Cooldown)
            NetworkClient.Bombs.Use.Invoke("Nuke", workspace:GetServerTimeNow())
            player.Bombs.Nukes:set(peek(player.Bombs.Nukes) - 1)
        end
    end, false, Enum.KeyCode.Three)

    local self: BombController = {
        Start = Start,
    }

    return self
end

return BombController