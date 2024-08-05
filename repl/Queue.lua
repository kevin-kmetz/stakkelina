Queue = {}
_mt_Queue = {__index = Queue}

function Queue:new()

    local newQueue = {}
    newQueue._frontIndex = 1
    newQueue._backIndex = 1

    setmetatable(newQueue, _mt_Queue)
    return newQueue

end

function Queue:push(element)

    if element == nil then return end

    self[self._backIndex] = element
    self._backIndex = self._backIndex + 1

end

function Queue:pop()

    if not (self._backIndex > self._frontIndex) then return nil end

    local element = self[self._backIndex]
    self._backIndex = self._backIndex - 1

    return element

end

function Queue:getSize()
    return self._backIndex - self._frontIndex
end

function Queue:_normalize()

    if self._frontIndex == 1 then return end

    local adjustmentNeeded = self._frontIndex - 1

    for i = self._frontIndex, self._backIndex do
        self[i - adjustmentNeeded] = self[i]
    end

    self._backIndex = nil

end