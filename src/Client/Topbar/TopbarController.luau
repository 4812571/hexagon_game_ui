--!strict
--!native
--!nolint LocalShadow

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)
local Children = Fusion.Children
local peek = Fusion.peek

local Icons = require(Common.Icons)

local NetworkClient = require(ReplicatedStorage.NetworkClient)

local WindowController = require(Client.Window.WindowController)

local ClientPlayer = require(Client.Player.ClientPlayer)
type ClientPlayer = ClientPlayer.ClientPlayer

local Topbar = require(Client.Topbar.Topbar)
local TopbarParticle = require(Client.Topbar.TopbarParticle)

type Scope<T> = Fusion.Scope<typeof(Fusion) & T>

export type Controllers = {
    WindowController: WindowController.WindowController,
}

export type TopbarController = {
    Start: () -> (),
}

type ParticleKind = "Tile" | "Coin"

export type ParticleEntry = {
    Scope: Scope<{}>,

    Kind: ParticleKind,
    Amount: number,

    TargetPosition: Fusion.Value<Vector2>,
    Position: Fusion.Value<Vector2>,
    Speed: number,
}

local MAX_PARTITIONS = 6
local MIN_PARTITION_SIZE = 5
local DEPLOY_INTERVAL = 0.125

local function CommaFormatNumber(number: number): string
    local str = tostring(number)
    local result = ""
    local count = 0

    for i = #str, 1, -1 do
        result = str:sub(i, i) .. result
        count += 1
        if count % 3 == 0 and i > 1 then
            result = "," .. result
        end
    end

    return result
end

type Components = {
    Topbar: typeof(Topbar),
    TopbarParticle: typeof(TopbarParticle),
}

local function MoveTo(from: Vector2, to: Vector2, amount: number): Vector2
    local displacement = to - from
    local direction = displacement.Unit
    local distance = displacement.Magnitude

    if distance <= amount then
        return to
    else
        return from + direction * amount
    end
end

local function TopbarController(scope: Scope<{}>, player: ClientPlayer, controllers: Controllers): TopbarController
    local WindowController = controllers.WindowController
    
    local scope: Scope<Components> = scope:innerScope {
        Topbar = Topbar,
        TopbarParticle = TopbarParticle,
    }

    local coinsSmooth = scope:Spring(player.Coins.Coins, 25)
    local coinsBounce = scope:Spring(scope:Value(1), 12)
    
    scope:Observer(player.Coins.Coins):onChange(function()
        coinsBounce:addVelocity(2)
    end)

    local coinPosition = scope:Value(Vector2.zero)

    local coinsProps: Topbar.ItemProps = {
        Icon = Icons.Coin,
        Text = scope:Computed(function(use)
            return CommaFormatNumber(math.round(use(coinsSmooth)))
        end),
        BounceScale = coinsBounce,
        IconPositionOut = coinPosition,
        OnPurchase = function()
            print("Coins Purchased")
        end,
    }

    local tilesSmooth = scope:Spring(player.Hexagons.Tiles, 25)
    local tilesBounce = scope:Spring(scope:Value(1), 12)

    scope:Observer(player.Hexagons.Tiles):onChange(function()
        tilesBounce:addVelocity(2)
    end)

    local tilePosition = scope:Value(Vector2.zero)

    local tilesProps: Topbar.ItemProps = {
        Icon = Icons.Globe,
        Text = scope:Computed(function(use)
            return CommaFormatNumber(math.round(use(tilesSmooth)))
        end),
        BounceScale = tilesBounce,
        IconPositionOut = tilePosition,
        OnPurchase = function()
            print("Tiles Purchased")
        end,
    }

    local remainingTiles = scope:Computed(function(use)
        return 10000 - math.round(use(tilesSmooth) :: number)
    end)

    local completion = scope:Computed(function(use)
        return math.clamp(math.round(use(tilesSmooth) :: number) / 10000, 0, 1)
    end)

    local completionString = scope:Computed(function(use)
        return `{string.format("%.1f", use(completion) * 100)}%`
    end)

    local bar = scope:Topbar {
        Scale = 0.75,
        Position = UDim2.fromScale(0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0),

        LeftBar = tilesProps,

        RightBar = coinsProps,

        Text = scope:Computed(function(use): string?
            if use(WindowController.CurrentWindow) then
                return nil
            end
            
            if not use(player.Hexagons.IsInGame) then
                return nil
            end

            local remainingTiles = use(remainingTiles)

            if remainingTiles <= 0 then
                return "👑 Keep 10,000 tiles to win!"
            end

            return `👑 Gain {CommaFormatNumber(use(remainingTiles))} more tiles to WIN! ({use(completionString)} complete)`
        end)
    }

    local function Icon(kind: ParticleKind): string
        if kind == "Tile" then
            return Icons.Globe
        end

        if kind == "Coin" then
            return Icons.Coin
        end
    
        error("Unknown particle kind: " .. kind)
    end

    local function Target(kind: ParticleKind): Fusion.Value<Vector2>
        if kind == "Tile" then
            return tilePosition
        end

        if kind == "Coin" then
            return coinPosition
        end
    
        error("Unknown particle kind: " .. kind)
    end

    local function ApplyReward(kind: ParticleKind, amount: number)
        if kind == "Tile" then
            player.Hexagons.Tiles:set(peek(player.Hexagons.Tiles) + amount)
            return
        end

        if kind == "Coin" then
            player.Coins.AwardCoins(amount)
            return
        end

        error("Unknown particle kind: " .. kind)
    end

    local particleEntries: Fusion.Value<{ParticleEntry}> = scope:Value({})

    local function AnimateParticles(deltaTime: number)
        local entries = peek(particleEntries)
        
        local cleaning = {}

        for _, entry in entries do
            local targetPosition = peek(entry.TargetPosition)

            local newPosition = MoveTo(peek(entry.Position), targetPosition, peek(entry.Speed) * deltaTime)
            entry.Position:set(newPosition)

            if newPosition == targetPosition then
                ApplyReward(entry.Kind, entry.Amount)
                table.insert(cleaning, entry.Scope)
            end
        end

        for _, entryScope in cleaning do
            entryScope:doCleanup()
        end
    end

    local frame = scope:New "Frame" {
        Visible = scope:Computed(function(use)
            return use(WindowController.CurrentWindow) == nil
        end),

        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(1, 1),
        AnchorPoint = Vector2.new(0.5, 0.5),

        BackgroundTransparency = 1,

        [Children] = {
            bar,

            scope:ForValues(particleEntries, function(use: Fusion.Use, scope: Scope<Components>, entry: ParticleEntry)
                local remainingDistance = scope:Computed(function(use)
                    return (use(entry.TargetPosition) - use(entry.Position)).Magnitude
                end)

                local scale = scope:Computed(function(use)
                    return math.clamp(use(remainingDistance) / 250, 0, 1)
                end)

                return scope:TopbarParticle {
                    Icon = Icon(entry.Kind),
                    Position = scope:Computed(function(use)
                        return UDim2.fromOffset(use(entry.Position).X, use(entry.Position).Y)
                    end),
                    Size = UDim2.fromOffset(90, 90),
                    Scale = scale,
                }
            end),
        } :: {Fusion.Child}
    } :: Frame

    local function CreateParticle(kind: ParticleKind, amount: number)
        local targetPosition = Target(kind)

        local scope = scope:innerScope()
        
        local entry: ParticleEntry = {
            Scope = scope,
            Kind = kind,
            Amount = amount,
            TargetPosition = targetPosition,
            Position = scope:Value(frame.AbsolutePosition + frame.AbsoluteSize / 2),
            Speed = 1500,
        }

        table.insert(scope, function()
            local entries = peek(particleEntries)
            table.remove(entries, table.find(entries, entry))
            particleEntries:set(entries)
        end)

        local entries = peek(particleEntries)
        table.insert(entries, table.freeze(entry))
        particleEntries:set(entries)
    end

    local coinQueue = {}
    local tileQueue = {}
    local lastTime = 0

    local function Queue(kind: ParticleKind)
        if kind == "Coin" then
            return coinQueue
        end

        if kind == "Tile" then
            return tileQueue
        end

        error("Unknown particle kind: " .. kind)
    end

    local function QueueParticles(kind: ParticleKind, totalAmount: number)
        local totalParticles = math.min(MAX_PARTITIONS, math.ceil(totalAmount / MIN_PARTITION_SIZE))
        
        local particleSeries = {}
        local remainingAmount = totalAmount

        for remainingParticles = totalParticles, 1, -1 do
            local partitionSize = math.ceil(totalAmount / remainingParticles)
            table.insert(particleSeries, partitionSize)
            remainingAmount -= partitionSize
        end

        local queue = Queue(kind)

        for _, size in particleSeries do
            table.insert(queue, {Kind = kind, Amount = size})
        end
    end

    local function DeployParticles(deltaTime: number)
        local now = os.clock()

        if (now - lastTime) < DEPLOY_INTERVAL then
            return
        end

        lastTime = now

        local tileEntry = table.remove(tileQueue, 1)

        if tileEntry then
            CreateParticle("Tile", math.min(tileEntry.Amount, MIN_PARTITION_SIZE))
        end

        local coinEntry = table.remove(coinQueue, 1)

        if coinEntry then
            CreateParticle("Coin", math.min(coinEntry.Amount, MIN_PARTITION_SIZE))
        end
    end

    local function OnTileChanged(tiles: number)
        if tiles < 0 then
            ApplyReward("Tile", 0)
            return
        end

        QueueParticles("Tile", tiles)
    end

    local function OnCoinReward(coins: number)
        if coins <= 0 then
            error("Coin reward must be positive")
        end

        QueueParticles("Coin", coins)
    end

    local function OnTilesCleared()
        for _, entry in peek(particleEntries) do
            if entry.Kind == "Tile" then
                entry.Amount = 0
            end
        end

        player.Hexagons.Tiles:set(0)
    end

    local function Update(deltaTime: number)
        AnimateParticles(deltaTime)
        DeployParticles(deltaTime)
    end

    local function Start()
        NetworkClient.Hexagon.TileChanged.On(OnTileChanged)
        NetworkClient.Hexagon.TilesCleared.On(OnTilesCleared)
        NetworkClient.Hexagon.CoinReward.On(OnCoinReward)

        table.insert(scope, RunService.RenderStepped:Connect(Update))

        local screenGui = Instance.new("ScreenGui")
        screenGui.ResetOnSpawn = false
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        
        frame.Parent = screenGui
        screenGui.Parent = player.Player.PlayerGui
    end

    local self = {
        Start = Start
    }

    return self
end

return TopbarController