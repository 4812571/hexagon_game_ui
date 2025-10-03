--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages

local Observe = require(Packages.Observe)
local Signal = require(Packages.Signal)
local Fusion = require(Packages.Fusion)

local GenericBinder = require(script.Parent.GenericBinder)
type GenericBinder<T, B> = GenericBinder.GenericBinder<T, B>

export type Signal<T...> = Signal.Signal<T...>
export type Scope = Fusion.Scope<typeof(Fusion)>

export type Constructor<T, B> = (scope: Scope, object: T) -> B

export type Cleanup = () -> ()

export type CollectionBinder<B> = {
    Has: (object: Instance) -> boolean,
    Get: (object: Instance) -> B?,
    GetAll: () -> {B},

    GetAddedSignal: (object: Instance) -> Signal<B>,
    GetRemovingSignal: (object: Instance) -> Signal<B>,

    ObserveBinding: (object: Instance, callback: (binder: B) -> Cleanup?) -> Cleanup,
    ObserveBindings: (callback: (binder: B) -> Cleanup?) -> Cleanup,

    Bind: (scope: Scope, tag: string) -> Cleanup,
    BindIn: (scope: Scope, tag: string, container: Instance) -> Cleanup,
}

local function CollectionBinder<B>(constructor: Constructor<Instance, B>): CollectionBinder<B>
    local binder: GenericBinder<Instance, B> = GenericBinder(constructor)

    local function Bind(scope: Scope, tag: string): Cleanup
        return Observe.Tagged(tag, function(instance: Instance)
            binder.Add(scope, instance)

            return function()
                binder.Remove(instance)
            end
        end)
    end

    local function BindIn(scope: Scope, tag: string, container: Instance): Cleanup
        return Observe.Tagged(tag, function(instance: Instance)
            if not instance:IsDescendantOf(container) then
                return
            end

            local parentCleanup = Observe.Property(instance, "Parent", function(parent: Instance?)
                if instance:IsDescendantOf(container) then
                    binder.Add(scope, instance)
                else
                    binder.Remove(instance)
                end

                return nil
            end)

            return function()
                binder.Remove(instance)
                parentCleanup()
            end
        end)
    end

    local self: CollectionBinder<B> = {
        Has = binder.Has,
        Get = binder.Get,
        GetAll = binder.GetAll,

        GetAddedSignal = binder.GetAddedSignal,
        GetRemovingSignal = binder.GetRemovingSignal,

        ObserveBinding = binder.ObserveBinding,
        ObserveBindings = binder.ObserveBindings,

        Bind = Bind,
        BindIn = BindIn,
    }

    return self
end

return CollectionBinder