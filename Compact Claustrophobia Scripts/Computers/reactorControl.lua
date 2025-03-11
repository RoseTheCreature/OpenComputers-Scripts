-- This script controls the state of reactors via redstone, when needed

local sides = require("sides")
local component = require("component")
local event = require("event")
local colors = require("colors")
local rs = component.redstone
local tun = component.tunnel


local reacColors = {
  [1] = colors.green,
  [2] = colors.black,
  [3] = colors.white
}

local function updateReactor(reactor, neededState)
  local power
  if neededState then power = 15 else power = 0 end
  rs.setBundledOutput(sides.forward, reacColors[reactor], power)
  
  tun.send("Reactor state changed", reactor, neededState)
end


local function messageHandler(_, _, _, _, message, ...)
  if message == "All" then
    updateReactor(1, ...)
    updateReactor(2, ...)
    updateReactor(3, ...)
  else if message == "One" then
    updateReactor(...)
  end end
end

local function eventHandler(event, ...)
  if not event then event = "" end
  if event == "modem_message" then messageHandler(...) end
end

while true do
  eventHandler(event.pull(60))
end