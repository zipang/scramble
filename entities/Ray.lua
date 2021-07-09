--[[
    Ray Class
    Author: zipang
    github.com/zipang

    The Ray of Death is thrown by the Player to destroy targets in front of him
]]
Class = require("lib.hump.class")

local image = love.graphics.newImage("assets/img/ray-of-death.png")

Ray = Class({})

function Ray:init(world, x, y, vx)
	-- set initial position
	self.x, self.y = x, y
	self.vx = vx or 100

	-- register ourself to the world (bump)
	world:add(self, self:getCollisionRectangle())
	self.world = world
end

function Ray:getCollisionRectangle()
	return self.x + 5, self.y, 1, 1
end

function Ray:update(dt)
	if self.x > SCREEN_WIDTH then
		self:destroy()
		return
	end

	self.x = self.x + dt * self.vx

	self.world:move(self, self.x, self.y)
end

function Ray:destroy()
	self.world:remove(self)
end

function Ray:draw()
	love.graphics.draw(image, self.x, self.y)
end

return Ray
