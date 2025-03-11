-- This script recieves and stores info about battery levels, then broadcasts it to the "screenServer" and "reactorServer"

local component = require("component")
local event = require("event")
local tun = component.tunnel
local md = component.modem

-- Battery powers
local batPow = {
  [1] = 0,
  [2] = 0,
  [3] = 0
}

local function broadcastBats()
  md.broadcast(69, "Batteries", batPow[1], batPow[2], batPow[3])
end


local function updateBats(bat, pow)
  batPow[bat] = pow
  broadcastBats()
end

local function handleMessage(_, _, _, _, message, ...)
  if message == "Redstone update" then updateBats(...) else
  if message == "Give me statuses" then broadcastBats() end end
end

local function eventHandler(event, ...)
  if not event then event = "" end
  if event == "modem_message" then handleMessage(...) end
end

md.open(69)
tun.send("Give me battery status")
while true do
  eventHandler(event.pull(30))
end