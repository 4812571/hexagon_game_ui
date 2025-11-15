--!strict
--!native
--!nolint LocalShadow

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)
local peek = Fusion.peek
type Scope = Fusion.Scope<typeof(Fusion)>

local Icons = require(Common.Icons)

local HexagonUtil = require(Common.Hexagon.HexagonUtil)
local HexagonConfig = require(Common.Hexagon.HexagonConfig)
type Axial = HexagonUtil.Axial

local BombsConfig = require(Common.Bombs.BombsConfig)

local Clock = require(Common.Util.Clock)

local NetworkClient = require(ReplicatedStorage.NetworkClient)

local ClientBomb = require(Client.Bombs.ClientBomb)
type ClientBomb = ClientBomb.ClientBomb

local ClientPlayer = require(Client.Player.ClientPlayer)
type ClientPlayer = ClientPlayer.ClientPlayer

local WindowController = require(Client.Window.WindowController)

local GlobalScale = require(Client.Interface.GlobalScale)
local BombWindow = require(Client.Bombs.BombWindow)

local BombTemplate = ReplicatedStorage.Bombs.Bomb
local GoldBombTemplate = ReplicatedStorage.Bombs.GoldBomb
local NukeTemplate = ReplicatedStorage.Bombs.Nuke

local BOMB_HEIGHT = 50

type BombType = "Bomb" | "GoldBomb" | "Nuke"

local function Clone<T>(scope: Scope, instance: T & Instance): T
    local clone = instance:Clone()
    table.insert(scope, clone)
    return clone
end

local function BombModel(scope: Scope, bombType: BombType): Model
    if bombType == "Bomb" then
        return Clone(scope, BombTemplate :: Model)
    end

    if bombType == "GoldBomb" then
        return Clone(scope, GoldBombTemplate :: Model)
    end

    if bombType == "Nuke" then
        return Clone(scope, NukeTemplate :: Model)
    end

    error("Invalid bomb type: " .. bombType)
end

local function Rainbow(n: number, offset: number): ColorSequence
    local keypoints = {}

    for i = 0, n - 1 do
        local unitPosition = i / (n - 1)
        local hue = (unitPosition + offset) % 1
        local color = Color3.fromHSV(hue, 1, 1)
        table.insert(keypoints, ColorSequenceKeypoint.new(unitPosition, color))
    end

    return ColorSequence.new(keypoints)
end

type BombEntry = {
    Scope: Scope,
    Bomb: ClientBomb,
}

export type Controllers = {
    WindowController: WindowController.WindowController,
}

export type BombController = {
    Start: () -> (),
}

local BASE_SCALE = 1

local function BombController(scope: Scope, player: ClientPlayer, controllers: Controllers)
    local WindowController = controllers.WindowController

    local scope = scope:innerScope {
        Clock = Clock,
        GlobalScale = GlobalScale,
        BombWindow = BombWindow,
    }

    local bombs: {[number]: BombEntry} = {}

    local nextBombTime = scope:Value(0)
    local nextGoldBombTime = scope:Value(0)
    local nextNukeTime = scope:Value(0)

    local now = scope:Clock()

    local bombCooldown = scope:Computed(function(use)
        return use(nextBombTime) - use(now)
    end)

    local goldBombCooldown = scope:Computed(function(use)
        return use(nextGoldBombTime) - use(now)
    end)

    local nukeCooldown = scope:Computed(function(use)
        return use(nextNukeTime) - use(now)
    end)

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

    local bomb: BombWindow.BombEntry = {
        Icon = Icons.Bomb,

        Count = player.Bombs.Bombs,
        Cooldown = bombCooldown,
        
        CardTransparency = 0.5,

        Activated = function()
            if peek(bombCooldown) > 0 then
                return
            end

            if peek(player.Bombs.Bombs) <= 0 then
                return
            end

            nextBombTime:set((peek(now) :: number) + BombsConfig.Bomb.Cooldown)
            NetworkClient.Bombs.Use.Invoke("Bomb", workspace:GetServerTimeNow())
            player.Bombs.Bombs:set(peek(player.Bombs.Bombs) - 1)
        end,
    }

    local goldBomb: BombWindow.BombEntry = {
        Icon = Icons.GoldenBomb,

        Count = player.Bombs.GoldBombs,
        Cooldown = goldBombCooldown,

        CardTransparency = 0.5,

        Activated = function()
            if peek(goldBombCooldown) > 0 then
                return
            end

            if peek(player.Bombs.GoldBombs) <= 0 then
                return
            end

            nextGoldBombTime:set((peek(now) :: number) + BombsConfig.GoldBomb.Cooldown)
            NetworkClient.Bombs.Use.Invoke("GoldBomb", workspace:GetServerTimeNow())
            player.Bombs.GoldBombs:set(peek(player.Bombs.GoldBombs) - 1)
        end,
    }

    local nuke: BombWindow.BombEntry = {
        Icon = Icons.Rocket,

        Count = player.Bombs.Nukes,
        Cooldown = nukeCooldown,

        CardGradient = scope:New "UIGradient" {
            Color = scope:Computed(function(use)
                return Rainbow(5, 0.85)
            end),
            Rotation = 120,
        },

        Activated = function()
            if peek(nukeCooldown) > 0 then
                return
            end

            if peek(player.Bombs.Nukes) <= 0 then
                return
            end

            nextNukeTime:set((peek(now) :: number) + BombsConfig.Nuke.Cooldown)
            NetworkClient.Bombs.Use.Invoke("Nuke", workspace:GetServerTimeNow())
            player.Bombs.Nukes:set(peek(player.Bombs.Nukes) - 1)
        end,
    }

    local globalScale = scope:GlobalScale()
    
    local isActive = scope:Computed(function(use)
        return use(player.Hexagons.IsInGame) and not use(WindowController.CurrentWindow)
    end)

    local activeScale = scope:Computed(function(use)
        return if use(isActive) then 1 else 0
    end)

    local activeScaleSmooth = scope:Spring(activeScale, 25)
    
    local scale = scope:Computed(function(use)
        return BASE_SCALE * (use(globalScale) :: number) * (use(activeScaleSmooth) :: number)
    end)

    local bombWindow = scope:BombWindow {
        Scale = scale,
        Visible = scope:Computed(function(use)
            return use(activeScaleSmooth) > 0
        end),

        Position = UDim2.fromScale(0.5, 0.975),
        AnchorPoint = Vector2.new(0.5, 1),
        
        Bombs = {bomb, goldBomb, nuke},
    }

    local function Start()
        NetworkClient.Bombs.BombDeployed.On(OnBombDeployed)
        NetworkClient.Bombs.BombExploded.On(OnBombExploded)

        local screenGui = Instance.new("ScreenGui")
        screenGui.ResetOnSpawn = false
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

        bombWindow.Parent = screenGui
        screenGui.Parent = player.Player.PlayerGui
    end

    local self: BombController = {
        Start = Start,
    }

    return self
end

return BombController
