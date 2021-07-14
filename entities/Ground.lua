--[[
    Ground Class
    Author: zipang
    github.com/zipang

    The Ground class holds the grid of ground tiles 
    scrolling left
]]
Class = require("lib.hump.class")
local anim8 = require("lib.anim8.anim8")

local image

-- The ground is divided in 16x16 tiles
local cols = 32 + 1 -- SCREEN_WIDTH / 16 + 1

Ground = Class({})

Ground.levels = {
	"_____________//////=/==\\_\\\\F^^^_^^F/=/=\\F^^_^^///==\\\\__/=\\\\\\_____//=/=\\\\\\_////////////",
}

--[[ Return a matrix of available tiles :
     [ /, /, / ]   3 variants of up (climbing)
     [ =, =, = ]   3 variants of top tiles
     [ \, \, \ ]   3 variants of down
     [ _, _, _ ]   3 variants of bottom 
]]
local initTileset = function(grid)
	return {
		["/"] = grid:getFrames("1-3", 1),
		["="] = grid:getFrames("1-3", 2),
		["\\"] = grid:getFrames("1-3", 3),
		["_"] = grid:getFrames("1-3", 4),
	}
end

local findTile = function(symbol, tileset)
	local choices = tileset[symbol] or tileset["_"] -- when the symbol is not given we are on flat land
	return choices[math.random(#choices)]
end

local buildMap = function(initialHeight, level, tileset)
	local tiles = {}
	local x = 0
	local y = (SCREEN_HEIGHT - initialHeight) or 200
	local previousTile = { x = x, y = y, symbol = "_" }

	-- Loop over the letters from the level
	for i = 1, #level do
		local c = level:sub(i, i)
		x = (i - 1) * 16
		if previousTile.symbol == "\\" and (c == "\\" or c == "=") then
			y = y + 16
		elseif (previousTile.symbol == "/" or previousTile.symbol == "=") and c == "/" then
			y = y - 16
		end

		previousTile = { x = x, y = y, symbol = c, tile = findTile(c, tileset) }
		table.insert(tiles, previousTile)
	end

	return tiles
end

function Ground:init(tileset, color, speed, level, initialHeight)
	-- load the tileset
	local image = love.graphics.newImage("assets/img/" .. tileset .. ".png")
	local groundTileset = initTileset(anim8.newGrid(16, 16, image:getWidth(), image:getHeight()))
	self.image = image

	self.tiles = buildMap(initialHeight, level, groundTileset)

	-- Initial position
	self.x = -1
	self.color = color
	self.speed = speed
end

function Ground:getCollisionRectangle() end

function Ground:update(dt)
	self.x = math.floor(self.x - self.speed * dt + 0.5)
end

function Ground:draw()
	-- love.graphics.setColor(1, 0, 0)
	-- Find the first tile to draw
	local start = math.floor(-self.x / 16)

	for i = 1, cols do
		local tile = self.tiles[start + i]
		if tile then
			love.graphics.draw(self.image, tile.tile, self.x + tile.x, tile.y)
			-- love.graphics.rectangle("fill", self.x + tile.x, tile.y + 16, 16, 200)
		end
	end

	-- love.graphics.setColor(1, 1, 1)
end

return Ground
