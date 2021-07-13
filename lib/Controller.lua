--[[
    Controller Class
    Author: zipang
    github.com/zipang

    The Controller is responsible for unifying all INPUTS (keyboard, gamepads)
    into a single object.
    Actions can be registered on specific keys or buttons evants
]]
Class = require("lib.hump.class")

local unpack = unpack or table.unpack
local isKeyDown = love.keyboard.isDown
local PLAYER1, PLAYER2 = unpack(love.joystick.getJoysticks())

-- Load some custom Gamepad mappings
love.joystick.loadGamepadMappings(
	"0500000049190000020400001b010000,GamepadPlus,a:b0,b:b1,x:b3,y:b4,back:b10,start:b11,leftstick:b13,rightstick:b14,leftshoulder:b6,rightshoulder:b7,dpup:h0.1,dpdown:h0.4,dpleft:h0.8,dpright:h0.2,leftx:a0,lefty:a1,rightx:a2,righty:a3,lefttrigger:b8,righttrigger:b9,platform:Linux,"
)
love.joystick.loadGamepadMappings(
	"030000003512000011ab000010010000,8BitDo FC30,a:b2,b:b1,x:b3,y:b0,back:b6,start:b7,leftshoulder:b4,rightshoulder:b5,dpup:a1,dpleft:a0,dpdown:a2,dpright:a3,platform:Linux,"
)
love.joystick.loadGamepadMappings(
	"0500000038426974646f204643333000,8Bitdo FC30 Bluetooth,a:b1,b:b0,x:b4,y:b3,back:b10,start:b11,leftshoulder:b6,rightshoulder:b7,dpleft:h0.8,dpright:h0.2,dpup:h0.1,platform:Linux,"
)

Controller = Class({})

function Controller:init(player1_definitions, player2_definitions)
	if PLAYER1 then
		print("DETECTED GAMEPAD #1 : '" .. PLAYER1:getName() .. "' [" .. PLAYER1:getGUID() .. "]")
	end
	if PLAYER2 then
		print("DETECTED GAMEPAD #2 : '" .. PLAYER2:getName() .. "' [" .. PLAYER2:getGUID() .. "]")
	end

	player1_definitions = player1_definitions or {}
	player2_definitions = player2_definitions or {}

	self.actions_definitions = {
		keyboard = {
			player1_definitions.keyboard or {},
			player2_definitions.keyboard or {},
		},
		gamepad = {
			player1_definitions.gamepad or {},
			player2_definitions.gamepad or {},
		},
	}
	self.playerActions = { {}, {} } -- player1 table, player 2 table

	-- Auto-register
	function love.gamepadpressed(joystick, button)
		self:onGamepadpressed(joystick, button)
	end
	-- function love.gamepadreleased(joystick, button)
	-- self:onGamepadpressed(joystick, button)
	-- end
end

function Controller:reset()
	-- for i = 1, 2 do
	-- 	local actions = self.playerActions[i]
	-- 	for j = 1, #actions do
	-- 		actions[j] = nil
	-- 	end
	-- end
	self.playerActions = { {}, {} } -- player1 table, player 2 table
end

function Controller:action(playerIndex, action)
	return self.playerActions[playerIndex][action] or false
end

function Controller:hasGamepad(playerIndex)
	if playerIndex == 1 then
		return PLAYER1 ~= nil
	elseif playerIndex == 2 then
		return PLAYER2 ~= nil
	else
		return false
	end
end

-- Call this inside love.keypressed
function Controller:onKeypressed(key)
	local def1, def2 = unpack(self.actions_definitions.keyboard)

	-- Check for key mappings existing on player 1
	if def1[key] then
		table.insert(self.playerActions[1], def1[key])
	elseif def2[key] then -- and on player 2..
		table.insert(self.playerActions[2], def2[key])
	end
end

-- Call this inside love.gamepadpressed
function Controller:onGamepadpressed(joystick, button)
	local def1, def2 = unpack(self.actions_definitions.gamepad)
	local buttonPressed = "_" .. button -- This action is true as long as the button is pressed

	-- Check for gamepad mappings on player 1
	if joystick == PLAYER1 then
		if def1[button] then
			print("DOWN #1", button, "mapped to", def1[button])
			table.insert(self.playerActions[1], def1[button])
		elseif def1[buttonPressed] then
			print("DOWN #1", button, "mapped to", def1[buttonPressed])
			self.playerActions[1][def1[buttonPressed]] = true
		end
	end

	-- Check for gamepad mappings on player 2
	if joystick == PLAYER2 and def2[button] then
		if def2[button] then
			print("DOWN #2", button, "mapped to", def2[button])
			table.insert(self.playerActions[2], def2[button])
		elseif def2[buttonPressed] then
			print("DOWN #1", button, "mapped to", def1[buttonPressed])
			self.playerActions[2][def2[buttonPressed]] = true
		end
	end
end

function Controller:onGamepadreleased(joystick, button)
	local def1, def2 = unpack(self.actions_definitions.gamepad)
	local buttonPressed = "_" .. button

	if joystick == PLAYER1 and def1[buttonPressed] then
		self.playerActions[1][def1[buttonPressed]] = false
	elseif joystick == PLAYER2 and def2[buttonPressed] then
		self.playerActions[2][def2[buttonPressed]] = false
	end
end

function Controller:update(dt)
	local actions_player1, actions_player2 = unpack(self.playerActions)

	-- Arrow keys are allways mapped to the player 1
	if isKeyDown("right") then
		actions_player1.right = true
	elseif isKeyDown("left") then
		actions_player1.left = true
	end
	if isKeyDown("up") then
		actions_player1.up = true
	elseif isKeyDown("down") then
		actions_player1.down = true
	end

	-- Map Gamepad 1 directions
	if PLAYER1 then
		local leftx = PLAYER1:getGamepadAxis("leftx")
		if leftx < 0 then
			actions_player1.left = true
		elseif leftx > 0 then
			actions_player1.right = true
		end
		local lefty = PLAYER1:getGamepadAxis("lefty")
		if lefty > 0 then
			actions_player1.down = true
		elseif lefty < 0 then
			actions_player1.up = true
		end
	end

	-- Map Gamepad 2 directions
	if PLAYER2 then
		local leftx = PLAYER2:getGamepadAxis("leftx")
		if leftx < 0 then
			actions_player2.left = true
		elseif leftx > 0 then
			actions_player2.right = true
		end
		local lefty = PLAYER2:getGamepadAxis("lefty")
		if lefty > 0 then
			actions_player2.down = true
		elseif lefty < 0 then
			actions_player2.up = true
		end
	end

	return { actions_player1, actions_player2 }
end

return Controller
