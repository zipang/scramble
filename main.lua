-- the "Class" library from Hump
--
-- https://github.com/vrld/hump
Class = require("lib.hump.class")

-- the virtualization library
--
-- https://github.com/vrld/hump/blob/master/class.lua
local aspect = require("lib.aspect")

local ScrollingBackground = require("entities.ScrollingBackground")
local Player = require("entities.Player")
local Fuel = require("entities.Fuel")

-- Setup the initial window size
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- Define the virtual screen size
SCREEN_WIDTH = 512 -- 32 x 16
SCREEN_HEIGHT = 288 -- 18 x 16
aspect.setGame(SCREEN_WIDTH, SCREEN_HEIGHT)

local world, skyBg, starsBg, player

function love.load()
	love.window.setTitle("Scramble")
	love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { resizable = true })
	-- Do not apply blur on resizing
	love.graphics.setDefaultFilter("nearest", "nearest")

	-- Define entities
	skyBg = ScrollingBackground("background-galaxy", -10, SCREEN_WIDTH, SCREEN_HEIGHT)
	starsBg = ScrollingBackground("background-stars", -20, SCREEN_WIDTH, SCREEN_HEIGHT)
	player = Player(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2)
end

function love.update(dt)
	aspect.update()
	skyBg:update(dt)
	starsBg:update(dt)
	player:update(dt)
end

function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	end
end

function love.draw()
	aspect.start()

	skyBg:draw()
	starsBg:draw()
	player:draw()

	aspect.stop()
end
