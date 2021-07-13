-- https://github.com/Vovkiv/love_dumb/blob/main/aspect/aspect.lua

local r, g, b, a = 0, 0, 0, 1

local lovePop, lovePush, loveTranslate, loveScale, loveColor, loveRectangle, loveBackground, loveWidth, loveHeight, abs =
	love.graphics.pop,
	love.graphics.push,
	love.graphics.translate,
	love.graphics.scale,
	love.graphics.setColor,
	love.graphics.rectangle,
	love.graphics.getBackgroundColor,
	love.graphics.getWidth,
	love.graphics.getHeight,
	math.abs

local windowWidth, windowHeight, windowAspect
local gameWidth, gameHeight, gameAspect = 800, 600, 800 / 600
local x1, y1, w1, h1, x2, y2, w2, h2
local xoff, yoff
local scale
local a_

local function setWindow(w, h)
	windowWidth, windowHeight, windowAspect = w, h, w / h
end

setWindow(loveWidth(), loveHeight())

local module = {
	setColor = function(r1, g1, b1, a1)
		r, g, b, a = r1, g1, b1, a1
	end,
	getColor = function()
		return r, g, b, a
	end,

	setGame = function(w, h, wW, wH)
		gameWidth, gameHeight = w, h
		if wW then
			setWindow(wW, wH)
		end
	end,
	getGame = function()
		return gameWidth, gameHeight
	end,

	getGameWidth = function()
		return gameWidth
	end,
	getGameHeight = function()
		return gameHeight
	end,

	getOff = function()
		return xoff, yoff
	end,
	getXOff = function()
		return xoff
	end,
	getYOff = function()
		return yoff
	end,

	getScale = function()
		return scale
	end,

	getWindow = function()
		return windowWidth, windowHeight
	end,
	getWindowWidth = function()
		return windowWidth
	end,
	getWindowHeight = function()
		return windowHeight
	end,

	update = function()
		gameAspect = gameWidth / gameHeight
		if gameAspect > windowAspect then
			scale = windowWidth / gameWidth
			a_ = abs((gameHeight * scale - windowHeight) / 2)
			x1, y1, w1, h1 = 0, 0, windowWidth, a_
			x2, y2, w2, h2 = 0, windowHeight, windowWidth, -a_
			xoff, yoff = 0, windowHeight / 2 - (scale * gameHeight) / 2
		elseif gameAspect < windowAspect then
			scale = windowHeight / gameHeight
			a_ = abs((gameWidth * scale - windowWidth) / 2)
			x1, y1, w1, h1 = 0, 0, a_, windowHeight
			x2, y2, w2, h2 = windowWidth, 0, -a_, windowHeight
			xoff, yoff = windowWidth / 2 - (scale * gameWidth) / 2, 0
		else
			scale = windowWidth / gameWidth
			x1, y1, w1, h1 = 0, 0, 0, 0
			x2, y2, w2, h2 = 0, 0, 0, 0
			xoff, yoff = 0, 0
		end
	end,

	start = function()
		lovePush()
		loveTranslate(xoff, yoff)
		loveScale(scale, scale)
	end,

	stop = function()
		lovePop()
		lovePush("all")
		loveColor(r, g, b, a)
		loveRectangle("fill", x1, y1, w1, h1)
		loveRectangle("fill", x2, y2, w2, h2)
		lovePop()
	end,
}

module.setWindow = setWindow

return module
