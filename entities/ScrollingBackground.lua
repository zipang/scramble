--[[
    ScrollingBackground Class
    Author: zipang
    github.com/zipang

    The ScrollingBackground class represents a background image that consistently
    move on the horizontal axis
]]
Class = require("lib.hump.class")

ScrollingBackground = Class({})

function ScrollingBackground:init(image, scrolling_speed, worldWidth, worldHeight)
	local bgImage = love.graphics.newImage("assets/img/" .. image .. ".png")
	bgImage:setWrap("repeat", "repeat")
	self.x = 0
	self.vx = scrolling_speed
	self.image = bgImage
	self.w = worldWidth
	self.h = worldHeight
	self.texture = love.graphics.newQuad(0, 0, worldWidth, worldHeight, bgImage:getDimensions())
end

function ScrollingBackground:getRectangle()
	return self.x, 0, unpack(self.dimensions)
end

function ScrollingBackground:update(dt)
	self.x = (self.x + dt * self.vx)
	self.texture:setViewport(-self.x, 0, self.w, self.h)
end

function ScrollingBackground:draw()
	love.graphics.draw(self.image, self.texture)
end

return ScrollingBackground
