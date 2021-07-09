--[[
    Bomb Class
    Author: zipang
    github.com/zipang

    The Bomb is thrown by the Player to destroy ground targets
]]
Class = require("lib.hump.class")

local image = love.graphics.newImage("assets/img/bomb.png")
local gravity = 40

Bomb = Class({})

function Bomb:init(world, x, y, vx)
	-- set initial position
	self.x, self.y = x, y
	self.vx = vx
	self.vy = 0

	-- register ourself to the world (bump)
	world:add(self, self:getCollisionRectangle())
	self.world = world
end

function Bomb:getCollisionRectangle()
	return self.x, self.y, 4, 4
end

function Bomb:update(dt)
	if self.x > SCREEN_WIDTH or self.y > SCREEN_HEIGHT then
		self:destroy()
		return
	end

	self.vy = self.vy + dt * gravity
	self.x = self.x + dt * self.vx
	self.y = self.y + dt * self.vy

	self.world:move(self, self.x, self.y)
end

function Bomb:destroy()
	self.world:remove(self)
end

function Bomb:draw()
	love.graphics.draw(image, self.x, self.y)
end

return Bomb
