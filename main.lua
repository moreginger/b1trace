-- This example uses the included Box2D (love.physics) plugin!!

local sti = require "sti"
local Gamestate = require "hump.gamestate"

local Chassis = require 'chassis'
local Player = require 'player'
local Tyre = require 'tyre'

local game = {};

function love.load()
    Gamestate.registerEvents()
    Gamestate.switch(game)
end

function game:init()
	love.physics.setMeter(32)
	self.world = love.physics.newWorld(0, 0, true)
	self.players = {}
	local player = Player:new({
		chassis = Chassis:new(),
		frontTyre = Tyre:new(),
		rearTyre = Tyre:new(),
	})
	player:init(self.world)
	player:draw()
	self.players['p1'] = player

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

	-- Load a map exported to Lua from Tiled
	self.map = sti("assets/maps/track_magic_burst.lua", { "box2d" })

	-- Prepare collision objects
	self.map:box2d_init(self.world)

	-- Create a Custom Layer
	self.map:addCustomLayer("Sprite Layer", 3)
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
	self.players['p1']:update(dt)
	self.world:update(dt)
	self.map:update(dt)
end

function game:draw()
    tx, ty = 0
    s = 1
	-- Draw the map and all objects within
	love.graphics.setColor(255, 255, 255)
	self.map:draw(tx, ty, s)

	-- Draw Collision Map (useful for debugging)
	love.graphics.setColor(255, 0, 0)
	-- self.map:box2d_draw(tx, ty, s)

	-- love.graphics.setBackgroundColor(0.41, 0.53, 0.97)
	self.players['p1']:draw()
end