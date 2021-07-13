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
Missile = require("entities.Missile")

local anim8 = require("lib.anim8.anim8")

Player = Class({})

local GAMEPAD_MAPPING = {
	_dpup = "up", -- when the button is pressed
	_dpdown = "down",
	_dpleft = "left",
	_dpright = "right",
	b = "fire",
	a = "dropBomb",
	x = "launchMissile",
}

--
Player.PLAYER1_MAPPINGS = {
	keyboard = {
		lctrl = "fire",
		lshift = "launchMissile",
		lalt = "dropBomb",
	},
	gamepad = GAMEPAD_MAPPING,
}
Player.PLAYER2_MAPPINGS = {
	keyboard = {},
	gamepad = GAMEPAD_MAPPING,
}

function Player:init(world, playerIndex, x, y)
	local image = love.graphics.newImage("assets/img/starship-spritesheet-32x32.png")
	local animSpriteSheet = anim8.newGrid(32, 32, image:getWidth(), image:getHeight())

	self.image = image
	self.playerIndex = playerIndex

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

	-- register to the world (bump)
	world:add(self, self:getCollisionRectangle())
	self.world = world
	self.controller = world.controller
end

function Player:getCollisionRectangle()
	return self.x + 3, self.y + 10, 24, 11
end

local playerActions = {
	dropBomb = function(player)
		return Bomb(player.world, player.x + 15, player.y + 20, 80)
	end,
	fire = function(player)
		return Ray(player.world, player.x + 20, player.y + 15, 100)
	end,
	launchMissile = function(player)
		return Missile(player.world, player.x + 10, player.y + 22, 20, 100)
	end,
}

-- function Player:dropBomb()
-- 	return Bomb(self.world, self.x + 10, self.y + 22, 80)
-- end
-- function Player:fire()
-- 	return Ray(self.world, self.x + 20, self.y + 15, 100)
-- end
-- function Player:launchMissile()
-- 	return Missile(self.world, self.x + 10, self.y + 22, 20, 100)
-- end

function Player:update(dt)
	-- Get the list of actions to apply for our current player
	local actions = self.controller:update(dt)[self.playerIndex]

	if actions.right then
		self.vx = 70
		self.state = "cruise"
	elseif actions.left then
		self.vx = -70
		self.state = "still"
	else
		self.vx = 0
		self.state = "still"
	end
	if actions.up then
		self.vy = -70
	elseif actions.down then
		self.vy = 70
	else
		self.vy = 0
	end
	if actions.space then
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

	-- if actions.lctrl then
	-- 	self:dropBomb()
	-- end
	-- if actions.lshift then
	-- 	self:fire()
	-- end
	-- if actions.lalt then
	-- 	self:launchMissile()
	-- end
	-- if actions.x then
	-- 	self.state = "explode"
	-- end

	-- Calcul new requested position by applying acceleration and velocity params
	self.vx = self.vx + self.ax
	self.vy = self.vy + self.ay
	self.x = (self.x + dt * self.vx)
	self.y = (self.y + dt * self.vy)

	for _, action in pairs(actions) do
		if playerActions[action] then
			playerActions[action](self)
		end
	end

	-- Update the running animation
	self.states[self.state]:update(dt)
end

function Player:draw()
	self.states[self.state]:draw(self.image, self.x, self.y)
end

return Player
