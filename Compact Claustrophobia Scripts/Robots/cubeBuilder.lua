--[[
  This script contains the instructions to build the cubic recipes
  Those recipes are:
    - Ender Pearls
    - Every compact machine
]]

local robot = require("robot")
local rm = require("robotMovement")

local cubebuilder = {}

local function alignLayer(dontTurn)
  if not dontTurn then robot.turnAround() end
  rm.move('u')
  robot.placeDown()
end

-- s = slot of block to be placed when aligning
local function alignLine(side, slot)
  local turns = {
    ['r'] = robot.turnRight,
    ['l'] = robot.turnLeft
  }
  
  robot.select(slot)
  turns[side]()
  rm.moveAndPlace()
  turns[side]()
end

local function placeIrregLine(s1, s2)
  robot.select(s2)
  rm.moveAndPlace()
  robot.select(s1)
  rm.moveAndPlace()
end

-- Places the ring on the sides of the large machine
local function placeWallLayers()
  for j = 1, 3, 1 do
    rm.moveAndPlace(4)
    robot.turnRight()
  end
  rm.moveAndPlace(3)
  rm.move()
  robot.turnRight()
end

-- Ring layer = ring of uniform blocks with a different one in the middle
local function placeRingLayer()
  rm.moveAndPlace(2)
  alignLine('r', 1)
  placeIrregLine(1, 2)
  alignLine('l', 1)
  rm.moveAndPlace(2)
end

-- Used for middle layer of giant/max machines
local function placeIrregLayer()
  placeIrregLine(1, 2)
  alignLine('r', 2)
  placeIrregLine(2, 3)
  alignLine('l', 1)
  placeIrregLine(1, 2)
end

local function placeUniformLayer(big, slot)
  if not slot then slot = 1 end
  if not big then
    rm.moveAndPlace(2)
    alignLine('r', 1)
    rm.moveAndPlace(2)
    alignLine('l', 1)
    rm.moveAndPlace(2)
  else
    for i = 1, 2, 1 do
      rm.moveAndPlace(4)
      alignLine('r', slot)
      rm.moveAndPlace(4)
      alignLine('l', slot)
    end
    rm.moveAndPlace(4)
  end
end

local function goToEndSpot(big)
  if not big then
    rm.move('b', 3)
    robot.turnRight()
    rm.move('b', 2)
    rm.move('d', 2)
    robot.turnLeft()
  else
    rm.move('b')
    rm.move('d', 4)
  end
end

-- Normal and Small machines
function cubebuilder.craftRegCube()
  rm.moveAndPlace()
  placeUniformLayer()
  alignLayer()
  placeRingLayer()
  alignLayer()
  placeUniformLayer()
  goToEndSpot()
end

-- Giant and Max machines
function cubebuilder.craftSpecialCube()
  rm.moveAndPlace()
  placeRingLayer()
  alignLayer()
  placeIrregLayer()
  alignLayer()
  placeRingLayer()
  goToEndSpot()
end

-- Large machines (5x5 recipe)
function cubebuilder.craftBigCube()
  print("Would craft the big cube")
  -- Sets blocks up properly
  robot.transferTo(2, 7)

  rm.moveAndPlace()
  placeUniformLayer(true)
  alignLayer()
  placeWallLayers()
  alignLayer(true)
  placeWallLayers()
  robot.select(2)
  alignLayer(true)
  placeWallLayers()
  alignLayer(true)
  placeUniformLayer(true, 2)

  robot.turnAround()
  robot.select(4)
  robot.drop()

  goToEndSpot(true)
end

return cubebuilder