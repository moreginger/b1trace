Player = {
    x = 0,
    y = 0,
    r = 0,
    vx = 0,
    vy = 0,
    vr = 0,
    dr = 1, -- 1/-1
}

function Player:update(dt)
    -- TODO: frictionwrong, need to calculate this correctly with dt
    local angularFriction = 10
    angularFriction = 1 - angularFriction * dt
    self.vr = self.vr * angularFriction

    local linearFriction = 5
    linearFriction = 1 - linearFriction * dt
    self.vx = self.vx * linearFriction
    self.vy = self.vy * linearFriction

    -- TODO: all wrong, not properly accounting for friction with dt
    local angularHorses = 20
    self.vr = self.vr + self.dr * dt * angularHorses

    local linearHorses = 1000
    self.vx = self.vx + -math.cos(self.r) * dt * linearHorses
    self.vy = self.vy + -math.sin(self.r) * dt * linearHorses

    self.r = self.r + self.vr * dt
    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt
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
    local brake = 0.5
    self.dr = -self.dr
    self.vx = self.vx * (1 - brake)
    self.vy = self.vy * (1 - brake)
end

function Player:new (o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

