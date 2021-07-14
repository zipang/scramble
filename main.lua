-- the "Class" library from Hump
-- https://hump.readthedocs.io/en/latest/class.html
Class = require("lib.hump.class")

-- the virtualization library
--
-- https://github.com/vrld/hump/blob/master/class.lua
local aspect = require("lib.aspect")

-- the world keeper :
-- register entities, check for collisions, bumps
-- https://github.com/kikito/bump.lua
local bump = require("lib.bump.bump")

local Controller = require("lib.Controller")

local ScrollingBackground = require("entities.ScrollingBackground")
local Player = require("entities.Player")
local Ground = require("entities.Ground")

DEBUG = true
PAUSE = false

-- Setup the initial window size
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- Define the virtual screen size
SCREEN_WIDTH = 512 -- 32 x 16
SCREEN_HEIGHT = 288 -- 18 x 16
aspect.setGame(SCREEN_WIDTH, SCREEN_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT)

local world, controller, skyBg, starsBg, ground

-- Game difficulty is indexed on speed
BABY_SPEED = 40
DEFAULT_SPEED = 70
HARDCORE_SPEED = 100

function love.load()
	love.window.setTitle("Scramble")
	love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { resizable = true })
	-- Do not apply blur on resizing
	love.graphics.setDefaultFilter("nearest", "nearest")

	-- Define the world
	world = bump.newWorld(16)

	-- and its controller
	controller = Controller(Player.PLAYER1_MAPPINGS, Player.PLAYER2_MAPPINGS)
	world.controller = controller

	-- Define entities
	skyBg = ScrollingBackground("background-galaxy", -10, SCREEN_WIDTH, SCREEN_HEIGHT)
	starsBg = ScrollingBackground("background-stars", -20, SCREEN_WIDTH, SCREEN_HEIGHT)
	ground = Ground("ground-tileset-16x16", "red", DEFAULT_SPEED, Ground.levels[1], SCREEN_HEIGHT / 4)

	-- Define the players positions
	Player(world, 1, SCREEN_WIDTH / 4, SCREEN_HEIGHT / 4 - 20, DEFAULT_SPEED) -- GET READY PLAYER #1
	if controller:hasGamepad(2) then
		Player(world, 2, SCREEN_WIDTH / 4, 3 * SCREEN_HEIGHT / 4 - 20, DEFAULT_SPEED) -- GET READY PLAYER #2
	end
end

function love.update(dt)
	if PAUSE then
		return
	end

	aspect.update()

	-- static entities
	skyBg:update(dt)
	starsBg:update(dt)
	ground:update(dt)

	-- dynamic entities that are registered on the world
	local entities = world:getItems()
	for i = 1, #entities do
		entities[i]:update(dt)
	end
end

function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	elseif ke == "space" then
		PAUSE = not PAUSE
	else
		controller:onKeypressed(key)
	end
end

function love.resize(w, h)
	aspect.setWindow(w, h)
end

function love.draw()
	aspect.start()

	skyBg:draw()
	starsBg:draw()
	ground:draw()

	local entities = world:getItems()
	for i = 1, #entities do
		entities[i]:draw()
	end

	if DEBUG then
		love.graphics.print("FPS: " .. tostring(love.timer.getFPS()) .. ", entities: " .. #entities, 375, 260)
	end

	controller:reset() -- raz every actions detections

	aspect.stop()
end
