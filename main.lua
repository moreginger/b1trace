-- This example uses the included Box2D (love.physics) plugin!!

local sti = require "sti"
local Gamestate = require "hump.gamestate"

local game = {};

function love.load()
    Gamestate.registerEvents()
    Gamestate.switch(game)
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
			x = 256,
			y = 12,
			r = 0,
		}
	}

	-- Update callback for Custom Layer
	function spriteLayer:update(dt)
		for _, sprite in pairs(self.sprites) do
			-- sprite.r = sprite.r + math.rad(90 * dt)
		end
	end

	-- Draw callback for Custom Layer
	function spriteLayer:draw()
		for _, sprite in pairs(self.sprites) do
			local x = math.floor(sprite.x)
			local y = math.floor(sprite.y)
			-- local r = sprite.r
			love.graphics.draw(sprite.image, x, y, math.pi / 2, 0.1, 0.1)
		end
	end
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