constants = require 'constants'
log = require 'log'

Player = {
    chassis = nil,
    frontTyre = nil,
    rearTyre = nil,
    jFrontTyre = nil,
    jRearTyre = nil,
}

function Player:init(world)
    local x, y = 300, 300
    self.chassis:init(world, x, y)
    local frontTyreOffset = -self.chassis.length / 2
    local rearTyreOffset = self.chassis.length / 2
    self.frontTyre:init(world, x, y + frontTyreOffset)
    self.rearTyre:init(world, x, y + rearTyreOffset)

    self.jFrontTyre = love.physics.newRevoluteJoint(self.chassis.body, self.frontTyre.body, x, y + frontTyreOffset, false)
    -- self.jFrontTyre:setLimits(0, 0)
    -- self.jFrontTyre:setLimitsEnabled(true)
    self.jRearTyre = love.physics.newRevoluteJoint(self.chassis.body, self.rearTyre.body, x, y + rearTyreOffset, false)
    self.jRearTyre:setLimits(0, 0)
    self.jRearTyre:setLimitsEnabled(true)

    -- TODO destroy
end

function Player:update(dt)
    self.frontTyre:update(dt)
    self.rearTyre:update(dt)
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
    self.frontTyre:control()
end

function Player:draw()
    self.frontTyre:draw()
    self.rearTyre:draw()
    self.chassis:draw()
end

function Player:new (o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

return Player
