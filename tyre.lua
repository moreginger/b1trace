constants = require 'constants'
vector = require 'hump.vector'

Tyre = {
    radius = constants.tyre_radius,
    width = constants.tyre_width,
    body = nil,
    shape = nil,
}

function Tyre:init(world)
    self.body = love.physics.newBody(world, 100, 100, 'dynamic')
    self.shape = love.physics.newRectangleShape(self.width, self.radius * 2)
    love.physics.newFixture(self.body, self.shape, 1)
    self.body:setUserData(self)

    self.body:applyLinearImpulse(0, 3)
    self.body:applyAngularImpulse(0.5)
end

function Tyre:destroy()
    self.body.destroy()
    self.shape.destroy()
end

function Tyre:update(dt)
    -- TODO use dt
    self:updateFriction()
end

function Tyre:getLateralVelocity()
    local vecN = vector(self.body:getWorldVector(1, 0))
    return vecN * vector(self.body:getLinearVelocity()) * vecN
end

function Tyre:updateFriction()
    local i = self.body:getMass() * -self:getLateralVelocity()
    self.body:applyLinearImpulse(i.x, i.y)
    self.body:applyAngularImpulse(0.1 * self.body:getInertia() * -self.body:getAngularVelocity())
end

function Tyre:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.polygon('fill', self.body:getWorldPoints(self.shape:getPoints()))
    x, y = self.body:getWorldPoints(self.shape:getPoints())
    love.graphics.print(x, 10, 0)
    love.graphics.print(y, 10, 20)
end

function Tyre:new (o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

return Tyre
