-- This example uses the included Box2D (love.physics) plugin!!

local sti = require "sti"
local Gamestate = require "hump.gamestate"

require('player')

local game = {};

function love.load()
    Gamestate.registerEvents()
    Gamestate.switch(game)
end

function game:init()
    self.players = {}
    self.players['p1'] = Player:new({
		x = 256,
		y = 12,
		r = - math.pi / 2,
	})

    self.bindings = {
        p1 = function() self.players['p1']:control() end,
    }
    self.keys = {
    }
    self.keysReleased = {
        space = "p1",
    }
    self.buttons = {}
    self.buttonsReleased = {}
end

function game:enter()
	-- Grab window size
	windowWidth  = love.graphics.getWidth()
	windowHeight = love.graphics.getHeight()

	-- Set world meter size (in pixels)
	love.physics.setMeter(32)

	-- Load a map exported to Lua from Tiled
	self.map = sti("assets/maps/map.lua", { "box2d" })

	-- Prepare physics world with horizontal and vertical gravity
	world = love.physics.newWorld(0, 0)

	-- Prepare collision objects
	self.map:box2d_init(world)

	-- Create a Custom Layer
	self.map:addCustomLayer("Sprite Layer", 3)

	-- Add data to Custom Layer
	local spriteLayer = self.map.layers["Sprite Layer"]
	spriteLayer.sprites = {
		player = {
			image = love.graphics.newImage("assets/sprites/Porsche_911/sprite.png"),
			-- TODO useful to set xyz here?
			-- x = 0,
			-- y = 0,
			-- r = 0,
		}
	}

	local players = self.players; -- TODO: Work out where to store this, in layer or what?

	-- Update callback for Custom Layer
	function spriteLayer:update(dt)
		for _, sprite in pairs(self.sprites) do
			players['p1']:update(dt)
			-- sprite.r = sprite.r + math.rad(90 * dt)
		end
	end

	-- Draw callback for Custom Layer
	function spriteLayer:draw()
		for _, sprite in pairs(self.sprites) do
			local p = players['p1'];
			love.graphics.draw(sprite.image, p.x, p.y, p.r, 0.1, 0.1, sprite.image:getWidth() / 2, sprite.image:getHeight() / 2)
		end
	end
end

function game:inputHandler(input)
    local action = self.bindings[input]
    if action then return action() end
end

function game:keypressed(k)
    local binding = self.keys[k]
    return self:inputHandler(binding)
end

function game:keyreleased(k)
    local binding = self.keysReleased[k]
    return self:inputHandler(binding)
end

function game:gamepadpressed(gamepad, button)
    local binding = self.buttons[button]
    return self:inputHandler(binding)
end

function game:gamepadreleased(gamepad, button)
    local binding = self.buttonsReleased[button]
    return self:inputHandler(binding)
end

function game:update(dt)
	self.map:update(dt)
end

function game:draw()
    tx, ty = 0
    s = 2
	-- Draw the map and all objects within
	love.graphics.setColor(255, 255, 255)
	self.map:draw(tx, ty, s)

	-- Draw Collision Map (useful for debugging)
	love.graphics.setColor(255, 0, 0)
	self.map:box2d_draw(tx, ty, s)
end