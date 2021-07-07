--[[
    ScrollingBackground Class
    Author: zipang
    github.com/zipang

    The ScrollingBackground class represents a background image that consistently 
    move on the horizontal axis
]]

ScrollingBackground = Class({})

function ScrollingBackground:init(image, scrolling_speed, scrolling_width)
	self.image = love.graphics.newImage("assets/img/" .. image .. ".png")
	self.x = 0
	self.vx = scrolling_speed
	self.scrolling_width = scrolling_width
end

function ScrollingBackground:update(dt)
	self.x = (self.x + dt * self.vx) % self.scrolling_width
end

function ScrollingBackground:render()
	love.graphics.draw(self.image, self.x, 0)
end
