--[[
  This script contains movement functions that allow for cleaner control over robots
  Credit to discord user "Xandaros" for teaching me how to make robot movement resistant to being blocked
]]

local robot = require("robot")

local robotmovement = {}

local movements = {
  ['u'] = robot.up,
  ['d'] = robot.down,
  ['f'] = robot.forward,
  ['b'] = robot.back
}
local placings = {
  ['f'] = robot.place, -- places forward
  ['u'] = robot.placeUp,
  ['d'] = robot.placeDown
}

-- d = direction, n = blocks to move
function robotmovement.move(d, n)
  if not d then d = 'f' end
  if not n then n = 1 end

  for i = 1, n, 1 do
    while not movements[d]() do end
  end
end

-- md = movement direction
-- pd = placement direction
function robotmovement.moveAndPlace(n, md, pd)
  if not md then md = 'f' end
  if not pd then pd = 'd' end
  if not n then n = 1 end

  for i=1, n do
    robotmovement.move(md)
    while not placings[pd]() do end
  end
end

return robotmovement -- allows to use this file as API