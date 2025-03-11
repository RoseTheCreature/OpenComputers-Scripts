-- This script contains instructions to build recipes of miscelaneous shapes

local rm = require("robotMovement")
local robot = require("robot")

local miscbuilder = {}

function miscbuilder.craftTunnel()
  -- Placing ring
  robot.select(3)
  rm.moveAndPlace(3)
  for i = 1, 3 do
    robot.turnRight()
    rm.moveAndPlace(i < 3 and 2 or 1) -- Places 2 blocks the first 2 times, then places 1 the last time
  end
  -- Placing the middle part
  robot.select(1)
  robot.turnRight()
  rm.moveAndPlace()
  robot.select(2)
  robot.turnRight()
  rm.moveAndPlace(1, 'b', 'f')

  -- Getting out of the craft area and dropping catalyst
  robot.turnLeft()
  rm.move('b', 2)
end

function miscbuilder.craftWall()
  robot.select(1)
  rm.moveAndPlace(1, 'd', 'f')
  robot.select(2)
  rm.moveAndPlace(1, 'u', 'f')
end

return miscbuilder