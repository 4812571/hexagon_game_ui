--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages

local Observe = require(Packages.Observe)
local Signal = require(Packages.Signal)
local Fusion = require(Packages.Fusion)

export type Signal<T...> = Signal.Signal<T...>
export type Scope = Fusion.Scope<typeof(Fusion)>    

export type Constructor<T, B> = (scope: Scope, object: T) -> B

local WEAK_KEYS = table.freeze({ __mode = "k" })

export type Binding<T> = {
    Binding: T,
    Scope: Scope,
}

export type Cleanup = () -> ()

export type GenericBinder<T, B> = {
    Has: (object: T) -> boolean,
    Get: (object: T) -> B?,
    GetAll: () -> {B},

    Add: (scope: Scope, object: T) -> B,
    Remove: (object: T) -> (),
    
    GetAddedSignal: (object: T) -> Signal<B>,
    GetRemovingSignal: (object: T) -> Signal<B>,

    ObserveBinding: (object: T, callback: (binder: B) -> Cleanup?) -> Cleanup,
    ObserveBindings: (callback: (binder: B) -> Cleanup?) -> Cleanup,
}

local function GenericBinder<T, B>(constructor: Constructor<T, B>)
    local added = Signal.new()
    local removing = Signal.new()

    local addedSignals: { [T]: Signal<B> } = setmetatable({}, WEAK_KEYS) :: any
    local removingSignals: { [T]: Signal<B> } = setmetatable({}, WEAK_KEYS) :: any

    local bindings: { [T]: Binding<B> } = {}

    local function Has(object: T): boolean
        return bindings[object] ~= nil
    end

    local function Get(object: T): B?
        local binding = bindings[object]

        if not binding then
            return nil
        end

        return binding.Binding
    end

    local function GetAll(): {B}
        local all = {}

        for _, binding in bindings do
            table.insert(all, binding.Binding)
        end

        return all
    end

    local function Add(scope: Scope, object: T): B
        local existing = Get(object)

        if existing then
            return existing
        end
        
        local objectScope = scope:innerScope()
        local bound = constructor(objectScope, object)

        bindings[object] = {
            Binding = bound,
            Scope = objectScope,
        }

        local addedSignal = addedSignals[object]

        if addedSignal then
            addedSignal:Fire(bound)
        end

        added:Fire(bound)

        return bound
    end

    local function Remove(object: T)
        local binding = bindings[object]

        if not binding then
            return
        end

        local removingSignal = removingSignals[object]

        if removingSignal then
            removingSignal:Fire(binding.Binding)
        end

        binding.Scope:doCleanup()
        bindings[object] = nil

        removing:Fire(binding.Binding)
    end

    local function GetAddedSignal(object: T): Signal<B>
        local existing = addedSignals[object]

        if existing then
            return existing
        end

        local newSignal = Signal.new() :: Signal<B>
        addedSignals[object] = newSignal

        return newSignal
    end

    local function GetRemovingSignal(object: T): Signal<B>
        local existing = removingSignals[object]

        if existing then
            return existing
        end

        local newSignal = Signal.new() :: Signal<B>
        removingSignals[object] = newSignal

        return newSignal
    end

    local function ObserveBinding(object: T, callback: (binder: B) -> Cleanup?): Cleanup
        local addedSignal = GetAddedSignal(object)
        local removingSignal = GetRemovingSignal(object)

        return Observe.SetClearSignals(Get(object), addedSignal, removingSignal, function(binder: B?)
            if not binder then
                return nil
            end

            return callback(binder)
        end)
    end

    local function ObserveBindings(callback: (binder: B) -> Cleanup?): Cleanup
        return Observe.AddedRemovedSignal(GetAll(), added, removing, callback)
    end

    local self: GenericBinder<T, B> = {
        Has = Has,
        Get = Get,
        GetAll = GetAll,

        GetAddedSignal = GetAddedSignal,
        GetRemovingSignal = GetRemovingSignal,

        Add = Add,
        Remove = Remove,

        ObserveBinding = ObserveBinding,
        ObserveBindings = ObserveBindings,
    }

    return self
end

return GenericBinder