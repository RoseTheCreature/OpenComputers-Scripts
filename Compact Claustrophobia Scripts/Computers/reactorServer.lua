-- This script sends signals to turn the fission reactors on/off depending on the battery levels

local component = require("component")
local event = require("event")
local tun = component.tunnel
local md = component.modem

local manualMode = false

local reacStats = {
  [1] = false,
  [2] = false,
  [3] = false
}

local function broadcastReacs()
  md.broadcast(69, "Reactors", reacStats[1], reacStats[2], reacStats[3], manualMode)
end

local function updateReacStats(reactor, status)
  reacStats[reactor] = status
  broadcastReacs()
end

-- Reactors turn on when battery 2 is empty, and turn off when they fill battery 1
local function autoReactors(b1, b2)
  if not manualMode then
    if b1 == 15 then tun.send("All", false) else
    if b2 == 0 then tun.send("All", true) end end
  end
end

local function manualReactors(reac)
  if manualMode then tun.send("One", reac, not reacStats[reac]) end
end

local function manualModeChange()
  manualMode = not manualMode
  -- if we turned manual mode off, turns off all reactors
  if not manualMode then tun.send("All", false) end
  broadcastReacs()
end

local validMessages = {
  ["Give me statuses"] = broadcastReacs,
  ["Reactor state changed"] = updateReacStats,
  ["Change manual mode"] = manualModeChange,
  ["Manual reactor change"] = manualReactors,
  ["Batteries"] = autoReactors
}

local function messageHandler(_, _, _, _, message, ...) validMessages[message](...) end

local function eventHandler(event, ...)
  if not event then event = "" end
  if event == "modem_message" then messageHandler(...) end
end

md.open(69)
while true do
  eventHandler(event.pull(60))
end