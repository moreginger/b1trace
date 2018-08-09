constants = require 'constants'
log = require 'log'
vector = require 'hump.vector'

Tyre = {
    dr = 1,
    radius = constants.tyre_radius,
    width = constants.tyre_width,
    body = nil,
    shape = nil,
    brakes = {},
}

function Tyre:init(world, x, y)
    self.body = love.physics.newBody(world, x, y, 'dynamic')
    self.body:setLinearDamping(constants.linear_damping)

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

    -- TODO max brakes
    self.brakes[#self.brakes+1]=constants.tyre_brake_total
end

function Tyre:applyLinearImpulse(v)
    self.body:applyLinearImpulse(v.x, v.y)
end

function Tyre:update(dt)
    local body, brakes = self.body, self.brakes;

    -- Correct direction
    self:applyLinearImpulse(body:getMass() * -self:getVelocityOn(vector(1, 0)))

    -- Steering
    self.body:applyAngularImpulse(dt * constants.tyre_angular_delta * self.dr)
    local angularOver = math.max(-constants.tyre_max_angular, math.min(constants.tyre_max_angular, self.body:getAngularVelocity()))
    self.body:applyAngularImpulse(-angularOver)

    -- Drive
    self:applyLinearImpulse(dt * constants.tyre_linear_delta * vector(body:getWorldVector(0, 1)))

    -- Brakes
    local brakeImpulse = 0
    for i=#brakes,1,-1 do
        local b = math.min(dt * constants.tyre_brake_delta, brakes[i])
        brakeImpulse = brakeImpulse + b
        brakes[i] = brakes[i] - b
        if brakes[i] <= 0 then
            table.remove(brakes, i)
        end
    end

    self:applyLinearImpulse(brakeImpulse * vector(body:getWorldVector(0, -1)))

    -- Debug
    -- log.info('brakeImpulse' .. brakeImpulse)
end

function Tyre:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.polygon('fill', self.body:getWorldPoints(self.shape:getPoints()))
end

function Tyre:new (o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

return Tyre
