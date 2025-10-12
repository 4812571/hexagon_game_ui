--!strict
--!native

type Node<T> = {
    Value: T,
    Next: Node<T>?,
}

export type Queue<T> = {
    IsEmpty: () -> boolean,

    Push: (value: T) -> (),
    Pop: () -> T?,
}

local function Queue<T>(): Queue<T>
    local head = nil
    local tail = nil

    local function IsEmpty(): boolean
        return head == nil
    end

    local function Push(value: T): ()
        local node: Node<T> = {
            Value = value,
            Next = nil,
        }

        if tail then
            tail.Next = node
        end

        if not head then
            head = node
        end

        tail = node
    end

    local function Pop(): T?
        if not head then
            return nil
        end

        local value = head.Value
        head = head.Next

        if not head then
            tail = nil
        end

        return value
    end

    local self: Queue<T> = {
        IsEmpty = IsEmpty,
        Push = Push,
        Pop = Pop,
    }

    return self
end

return Queue
