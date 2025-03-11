-- This script draws recieved info about batteries and reactors on a screen
-- It also has touchscreen functionality, which allows for manually turning reactors on/off via the screen

local event = require("event")
local component = require("component")
local keyboard = require("keyboard")
local tun = component.tunnel
local gpu = component.gpu

-- b = battery, r = reactor
local function drawScreen(_, _, _, _, b1, b2, b3, r1, r2, r3, manMo)
  gpu.fill(1, 1, 26, 10, " ") -- Clears screen
  
  gpu.set(1, 1, "Battery 1: "..b1)
  gpu.set(1, 2, "Battery 2: "..b2)
  gpu.set(1, 3, "Battery 3: "..b3)

  gpu.set(1, 5, "Reactor 1: "..r1)
  gpu.set(1, 6, "Reactor 2: "..r2)
  gpu.set(1, 7, "Reactor 3: "..r3)

  gpu.set(1, 10, "Manual mode: "..manMo)
end

local function handleKeyPress()
  if keyboard.isAltDown() then
    if keyboard.isKeyDown(keyboard.keys.c) then
      gpu.setResolution(80, 25)
      os.exit()
    end
  end
end

local function handleTouch(_, x, y)
  if x == 14 and y == 10 then tun.send("Change manual mode") else
    if x == 12 then
      local reactor
      if y == 5 then reactor = 1 else
      if y == 6 then reactor = 2 else
      if y == 7 then reactor = 3 end end end
      tun.send("Manual reactor change", reactor)
    end
  end
end

local function handleEvent(event, ...)
  if not event then event = "" end
  if event == "modem_message" then drawScreen(...) else
  if event == "key_down" then handleKeyPress() else
  if event == "touch" then handleTouch(...) end end end
end

gpu.setResolution(26, 10)

-- Gets all the info it can, draws the screen once, then goes eep until it gets an event
tun.send("Give me info")

while true do
  handleEvent(event.pull(30))
end