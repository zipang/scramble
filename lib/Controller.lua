--[[
    Controller Class
    Author: zipang
    github.com/zipang

    The Controller is responsible for unifying all INPUTS (keyboard, gamepads)
    into a single object.
    Actions can be registered on specific keys or buttons evants
]]
Class = require("lib.hump.class")

Controller = Class({})
local PLAYER1, PLAYER2 = unpack(love.joystick.getJoysticks())
local isKeyDown = love.keyboard.isDown

function Controller:init(player1_definitions, player2_definitions)
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
end

function Controller:reset()
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

	-- Check for gamepad mappings on player 1
	if joystick == PLAYER1 and def1[key] then
		table.insert(self.playerActions[1], def1[key])
	end

	-- Check for gamepad mappings on player 2
	if joystick == PLAYER2 and def2[key] then
		table.insert(self.playerActions[2], def2[key])
	end
end

function Controller:update(dt)
	local actions_player1, actions_player2 = unpack(self.playerActions)

	-- Arrow keys are allways mapped to the player 1
	if isKeyDown("right") then
		table.insert(actions_player1, "right")
	elseif isKeyDown("left") then
		table.insert(actions_player1, "left")
	end
	if isKeyDown("up") then
		table.insert(actions_player1, "up")
	elseif isKeyDown("down") then
		table.insert(actions_player1, "down")
	end

	-- Map Gamepad 1 directions
	if PLAYER1 then
		local leftx = PLAYER1:getGamepadAxis("leftx")
		if leftx < 0 then
			table.insert(actions_player1, "left")
		elseif leftx > 0 then
			table.insert(actions_player1, "right")
		end
		local lefty = PLAYER1:getGamepadAxis("lefty")
		if lefty < 0 then
			table.insert(actions_player1, "down")
		elseif lefty > 0 then
			table.insert(actions_player1, "up")
		end
	end

	-- Map Gamepad 2 directions
	if PLAYER2 then
		local leftx = PLAYER2:getGamepadAxis("leftx")
		if leftx < 0 then
			table.insert(actions_player2, "left")
		elseif leftx > 0 then
			table.insert(actions_player2, "right")
		end
		local lefty = PLAYER2:getGamepadAxis("lefty")
		if lefty < 0 then
			table.insert(actions_player2, "down")
		elseif lefty > 0 then
			table.insert(actions_player2, "up")
		end
	end

	return actions_player1, actions_player2 -- not the way to go
end

return Controller
