--!strict
--!native
--!nolint LocalShadow

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)
type Scope = Fusion.Scope<typeof(Fusion)>

local Icons = require(Common.Icons)

local WindowController = require(Client.Window.WindowController)

local ClientPlayer = require(Client.Player.ClientPlayer)
type ClientPlayer = ClientPlayer.ClientPlayer

local Topbar = require(Client.Topbar.Topbar)

export type Controllers = {
    WindowController: WindowController.WindowController,
}

export type TopbarController = {
    Start: () -> (),
}

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

local function TopbarController(scope: Scope, player: ClientPlayer, controllers: Controllers): TopbarController
    local WindowController = controllers.WindowController
    
    local scope = scope:innerScope {
        Topbar = Topbar,
    }

    local coinsSmooth = scope:Spring(player.Coins.Coins, 25)
    local coinsBounce = scope:Spring(scope:Value(1), 32)
    
    scope:Observer(player.Coins.Coins):onChange(function()
        coinsBounce:setVelocity(100)
    end)

    local coinsProps: Topbar.ItemProps = {
        Icon = Icons.Coin,
        Text = scope:Computed(function(use)
            return CommaFormatNumber(math.round(use(coinsSmooth)))
        end),
        BounceScale = coinsBounce,
        OnPurchase = function()
            print("Coins Purchased")
        end,
    }

    local tilesSmooth = scope:Spring(player.Hexagons.Tiles, 25)
    local tilesBounce = scope:Spring(scope:Value(1), 32)

    scope:Observer(0):onChange(function()
        tilesBounce:setVelocity(100)
    end)

    local tilesProps: Topbar.ItemProps = {
        Icon = Icons.Globe,
        Text = scope:Computed(function(use)
            return CommaFormatNumber(math.round(use(tilesSmooth)))
        end),
        BounceScale = tilesBounce,
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

    local function Start()
        local screenGui = Instance.new("ScreenGui")
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        
        bar.Parent = screenGui
        screenGui.Parent = player.Player.PlayerGui
    end

    local self = {
        Start = Start
    }

    return self
end

return TopbarController