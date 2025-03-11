-- This script relays info about battery status, reactor status 
-- and if manual reactor control is on/off to the "screenController"

local event = require("event")
local component = require("component")
local tun = component.tunnel
local md = component.modem

-- Battery strings to send to screen
local bats = {
  [1] = "no info",
  [2] = "no info",
  [3] = "no info"
}
local reacs = {
  [1] = "no info",
  [2] = "no info",
  [3] = "no info"
}
local manualMode = "no info"

local function updateScreen()
  tun.send(bats[1], bats[2], bats[3], reacs[1], reacs[2], reacs[3], manualMode)
end

local function updateBats(bat1, bat2, bat3)
  bats[1] = string.rep("■", bat1)..string.rep("□", 15-bat1)
  bats[2] = string.rep("■", bat2)..string.rep("□", 15-bat2)
  bats[3] = string.rep("■", bat3)..string.rep("□", 15-bat3)
  updateScreen()
end

local function updateReacs(r1, r2, r3, manMo)
  reacs[1] = r1 and "■" or "□"
  reacs[2] = r2 and "■" or "□"
  reacs[3] = r3 and "■" or "□"
  manualMode = manMo and "■" or "□"
  updateScreen()
end

local function changeManMo()
  md.broadcast(69, "Change manual mode")
end

local function manualReactorChange(reac)
  md.broadcast(69, "Manual reactor change", reac)
end

local validMessages = {
  ["Give me info"] = updateScreen,
  ["Batteries"] = updateBats,
  ["Reactors"] = updateReacs,
  ["Change manual mode"] = changeManMo,
  ["Manual reactor change"] = manualReactorChange
}

local function handleMessage(_, _, _, _, message, ...) validMessages[message](...) end

local function handleEvent(event, ...)
  if not event then event = "" end
  if event == "modem_message" then handleMessage(...) end
end

md.open(69)
md.broadcast(69, "Give me statuses")
while true do
  handleEvent(event.pull(30))
end