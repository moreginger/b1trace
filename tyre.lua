constants = require 'constants'
vector = require 'hump.vector'

Tyre = {
    dr = 1,
    radius = constants.tyre_radius,
    width = constants.tyre_width,
    body = nil,
    shape = nil,
}

function Tyre:init(world)
    self.body = love.physics.newBody(world, 300, 100, 'dynamic')
    self.body:setLinearDamping(constants.tyre_damping)

    self.shape = love.physics.newRectangleShape(self.width, self.radius * 2)
    love.physics.newFixture(self.body, self.shape, 1)
    self.body:setUserData(self)
end

function Tyre:destroy()
    self.body.destroy()
    self.shape.destroy()
end

function Tyre:getVelocityOn(v)
    local vecN = vector(self.body:getWorldVector(v.x, v.y))
    return vecN * vector(self.body:getLinearVelocity()) * vecN
end

function Tyre:control()
    self.dr = -self.dr
end

function Tyre:applyLinearImpulse(v)
    self.body:applyLinearImpulse(v.x, v.y)
end

function Tyre:update(dt)
    local body = self.body;

    -- Correct direction
    self:applyLinearImpulse(body:getMass() * -self:getVelocityOn(vector(1, 0)))

    -- Drive
    self:applyLinearImpulse(dt * constants.tyre_linear_delta * vector(body:getWorldVector(0, 1)))

    -- Steering
    self.body:applyAngularImpulse(dt * constants.tyre_angular_delta * self.dr)
    local angularOver = math.max(-constants.tyre_max_angular, math.min(constants.tyre_max_angular, self.body:getAngularVelocity()))
    self.body:applyAngularImpulse(-angularOver)
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
