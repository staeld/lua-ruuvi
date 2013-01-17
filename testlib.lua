#!/usr/bin/env lua
-- testlib.lua - A file to load and test the lua-ruuvi library
-- Copyright Stæld Lakorv, 2013 <staeld@illumine.ch>
-- This file is part of lua-ruuvi.
-- lua-ruuvi is released under the GPLv3 - see COPYING

ruuvi = require("ruuvi")

url = "http://dev-server.ruuvitracker.fi/api/v1-dev/" -- Testing server
server = ruuvi.new(url)

print("Testing direct call to ruuvi.aux.ping()")
--ruuvi.aux.ping(url)

print("Testing server object creation and pinging")
server:ping()

print("Testing tracker listing")
for i, t in ipairs(server:trackers()) do
    for k, v in pairs(t) do print(k,v) end
end

print("Testing event listing")
local arr = server:events()
for i, t in ipairs(arr) do
    for k, v in pairs(t) do print(k,v) end
end

print("Testing fetching of tracker IDs")
print(server:trackerId("fooo"), server:trackerId("sepeto"))
print(server:trackerName("1"), server:trackerCode("4"))

print()
print("Last activity reported by tracker 'foobar'")
id = server:trackerId("foobar")
timestring = server:trackers(id)[1].latest_activity
t = ruuvi.aux.toTimeTable(timestring)

trackerTime = os.time(t)
now = os.time(os.date("!*t"))
diff = os.difftime(now, trackerTime)

days = diff / ( 60*60 * 24 )
if days < 1 then
    days = days * 24
    days = string.format("%.1f hours", days)
else
    days = string.format("%.1f days", days)
end
print(timestring, ", which is " .. days .. " ago.")

-- EOF
