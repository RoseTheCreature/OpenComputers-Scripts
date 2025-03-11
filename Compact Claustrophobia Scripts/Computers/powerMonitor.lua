-- This script monitors the power level of 3 batteries using redstone, and sends it to the "powerServer"

local component = require("component")
local event = require("event")
local sides = require("sides")
local tun = component.tunnel
local rs = component.redstone

-- Relates side to the corresponding battery
local sidesTable = {
  [sides.left] = 1,
  [sides.front] = 2,
  [sides.right] = 3
}

local function updatePower(_, side, _, power) tun.send("Redstone update", sidesTable[side], power) end

-- Should get the redstone signals from all batteries and send it to the main monitor
local function updateAll()
  updatePower(nil, sides.left, nil, rs.getInput(sides.left))
  updatePower(nil, sides.front, nil, rs.getInput(sides.front))
  updatePower(nil, sides.right, nil, rs.getInput(sides.right))
end

local function handleMessage(_, _, _, _, message)
  if message == "Give me battery status" then updateAll() end
end

local function eventHandler(event, ...)
  if not event then event = "" end
  if event == "redstone_changed" then updatePower(...) end
  if event == "modem_message" then handleMessage(...) end
end

-- Main
updateAll()
while true do
  eventHandler(event.pull(30))
end