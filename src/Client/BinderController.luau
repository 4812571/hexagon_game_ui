local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Common = ReplicatedStorage.Common
local Client = ReplicatedStorage.Client

local Fusion = require(Packages.Fusion)
type Scope = Fusion.Scope<typeof(Fusion)>

local CollectionBinder = require(Common.Binder.CollectionBinder)
type CollectionBinder<B> = CollectionBinder.CollectionBinder<B>

local Binders = require(Client.Binders)

local function BinderController(scope: Scope)
    for name, binder in Binders do
        (binder :: CollectionBinder<any>).Bind(scope, name)
    end
end

return BinderController