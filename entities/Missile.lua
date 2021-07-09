--[[
    Missile Class
    Author: zipang
    github.com/zipang

    The Missile of Death is thrown by the Player to destroy targets in front of him
]]
Class = require("lib.hump.class")

local anim8 = require("lib.anim8.anim8")
local image = love.graphics.newImage("assets/img/missile.png")
local animSpriteSheet = anim8.newGrid(14, 5, image:getWidth(), image:getHeight())

Missile = Class({})

function Missile:init(world, x, y, vx, ax)
	-- set initial position
	self.x, self.y = x, y
	self.vx = vx or 50
	self.ax = ax or 50

	-- define the animation
	self.animation = anim8.newAnimation(animSpriteSheet("1-2", 1), 0.2)

	-- register ourself to the world (bump)
	world:add(self, self:getCollisionRectangle())
	self.world = world
end

function Missile:getCollisionRectangle()
	return self.x + 3, self.y, 11, 5
end

function Missile:update(dt)
	if self.x > SCREEN_WIDTH then
		self:destroy()
		return
	end

	self.vx = self.vx + dt * self.ax
	self.x = self.x + dt * self.vx

	self.animation:update(dt)
	self.world:move(self, self.x, self.y)
end

function Missile:destroy()
	self.world:remove(self)
end

function Missile:draw()
	self.animation:draw(image, self.x, self.y)
end

return Missile
