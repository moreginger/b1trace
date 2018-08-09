constants = require 'constants'
log = require 'log'

Chassis = {
    length = constants.body_length,
    width = constants.body_width,
}

function Chassis:init(world, x, y)
    self.body = love.physics.newBody(world, x, y, 'dynamic')
    self.body:setLinearDamping(constants.linear_damping)

    self.shape = love.physics.newRectangleShape(self.width, self.length)
    love.physics.newFixture(self.body, self.shape, 1)
    self.body:setUserData(self)
end

function Chassis:destroy()
    self.body.destroy()
    self.shape.destroy()
end

function Chassis:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.polygon('fill', self.body:getWorldPoints(self.shape:getPoints()))
end

function Chassis:new (o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

return Chassis
