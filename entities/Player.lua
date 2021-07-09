--[[
    Player Class
    Author: zipang
    github.com/zipang

    The Player class represents a background image that consistently
    move on the horizontal axis
]]
Class = require("lib.hump.class")
Bomb = require("entities.Bomb")
Ray = require("entities.Ray")

local anim8 = require("lib.anim8.anim8")
local isKeyDown = love.keyboard.isDown

Player = Class({})

function Player:init(x, y)
	local image = love.graphics.newImage("assets/img/starship-spritesheet-32x32.png")
	local animSpriteSheet = anim8.newGrid(32, 32, image:getWidth(), image:getHeight())

	self.image = image

	-- position
	self.x, self.y = x, y
	-- velocity
	self.vx, self.vy = 0, 0
	-- acceleration
	self.ax, self.ay = 0, 0

	self.states = {
		still = anim8.newAnimation(animSpriteSheet(1, 1, 6, 1), 0.6),
		cruise = anim8.newAnimation(animSpriteSheet("2-6", 1), 0.3),
		warp = anim8.newAnimation(animSpriteSheet("4-6", 1), 0.1),
		explode = anim8.newAnimation(animSpriteSheet("1-6", 2, "3-6", 3), 0.2, "pauseAtEnd"),
	}
	self.state = "still"
end

function Player:register(world)
	-- register to the world (bump)
	world:add(self, self:getCollisionRectangle())
	self.world = world
	return self
end

function Player:getCollisionRectangle()
	return self.x + 3, self.y + 10, 24, 11
end

function Player:dropBomb()
	return Bomb(self.world, self.x + 10, self.y + 22, 80)
end

function Player:fire()
	return Ray(self.world, self.x + 20, self.y + 15, 100)
end

function Player:update(dt)
	if isKeyDown("right") then
		self.vx = 70
		self.state = "cruise"
	elseif isKeyDown("left") then
		self.vx = -70
		self.state = "still"
	else
		self.vx = 0
		self.state = "still"
	end
	if isKeyDown("up") then
		self.vy = -70
	elseif isKeyDown("down") then
		self.vy = 70
	else
		self.vy = 0
	end
	if isKeyDown("space") then
		self.state = "warp"
		-- determine the acceleration direction
		if self.vx > 0 then
			self.ax = 4
		elseif self.vx < 0 then
			self.ax = -4
		end
		if self.vy > 0 then
			self.ay = 4
		elseif self.vy < 0 then
			self.ay = -4
		end
	else
		self.ax, self.ay = 0, 0
	end
	if isKeyDown("lctrl") then
		self:dropBomb()
	end
	if isKeyDown("lshift") then
		self:fire()
	end
	if isKeyDown("x") then
		self.state = "explode"
	end

	self.vx = self.vx + self.ax
	self.vy = self.vy + self.ay
	self.x = (self.x + dt * self.vx)
	self.y = (self.y + dt * self.vy)

	self.states[self.state]:update(dt)
end

function Player:draw()
	self.states[self.state]:draw(self.image, self.x, self.y)
end

return Player
