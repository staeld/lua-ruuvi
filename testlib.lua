#!/usr/bin/env lua
-- testlib.lua - A file to load and test the lua-ruuvi library
-- Copyright Stæld Lakorv, 2013 <staeld@illumine.ch>
-- This file is part of lua-ruuvi.
-- lua-ruuvi is released under the GPLv3 - see COPYING

local ruuvi = require("ruuvi")

local url = "http://dev-server.ruuvitracker.fi/api/v1-dev/" -- Testing server
local server = ruuvi.new(url)

print("Testing direct call to ruuvi.aux.ping()")
--ruuvi.aux.ping(url)

print("Testing server object creation and pinging")
--server:ping()

print("Testing tracker listing")
for i, t in ipairs(server:trackers()) do
    print(i)
    for k, v in pairs(t) do print(k,v) end
end

print("Testing event listing")
local arr = server:events()
print(arr['1'], arr[1], arr.id, arr.events)
for i, t in pairs(arr) do
    print(i, t)
    for k, v in pairs(t) do print(k,v) end
end

-- EOF
