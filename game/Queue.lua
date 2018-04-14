-- Queue class
local Queue = {}
Queue.__index = Queue

function Queue:create()
    local queue = {first = 0, last = -1}

     setmetatable(queue, self)

    --
    -- Queue Methods
    --
    function queue:push(value)
        local last = self.last + 1
        self.last  = last
        self[last] = value
    end

    function queue:pop()
        local first = self.first
        if first > self.last then
            error("queue is empty")
        end
        
        local ret = self[first]
        self[first] = nil
        if self.first == self.last then
            self.first = 0
            self.last  = -1
        else
            self.first = first + 1
        end
        return ret
    end

    function queue:len()
        return self.last - self.first + 1
    end

    function queue:clear()
        for i = self.first, self.last do
            self[i] = nil
        end
        self.first = 0
        self.last  = -1
    end

    return queue
end

return Queue