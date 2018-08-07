Player = {
    tyre = nil,
}

function Player:init(world)
   self.tyre:init(world)
end

function Player:update(dt)
    self.tyre:update(dt)
end

-- function Player:keypressed(key, collider)
--     if self.control:isChangeDirectionKey(key) then
--         self:_changeDirection(collider)
--     end
-- end

-- function Player:touchpressed(x, y, collider)
--     if self.control:isChangeDirectionTouch(x, y) then
--         self:_changeDirection(collider)
--     end
-- end

function Player:control()
    self.tyre:control()
end

function Player:draw()
    self.tyre:draw()
end

function Player:new (o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

return Player
