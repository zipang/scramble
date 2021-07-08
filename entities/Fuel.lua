--[[
    Fuel Class
    Author: zipang
    github.com/zipang

    The Fuel class represents a depot of fuel that tyhe player
    may destroy to its content
]]
Class = require("lib.hump.class")

local anim8 = require("lib.anim8.anim8")
local image = love.graphics.newImage("assets/img/fuel-tank-16x16.png")
local animSpriteSheet = anim8.newGrid(16, 16, image:getWidth(), image:getHeight())

Fuel = Class({})

function Fuel:init(x, y)
	-- position
	self.x, self.y = x or 0, y or 0

	self.states = {
		still = anim8.newAnimation(animSpriteSheet(1, 1), 1),
		explode = anim8.newAnimation(animSpriteSheet("2-7", 1), 0.2, "pauseAtEnd"),
	}
	self.state = "still"
end

function Fuel:getCollisionRectangle()
	return self.x + 2, self.y + 5, 13, 11
end

function Fuel:update(dt)
	self.states[self.state]:update(dt)
end

function Fuel:draw()
	self.states[self.state]:draw(image, self.x, self.y)
end

return Fuel
