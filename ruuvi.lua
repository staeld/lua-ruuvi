#!/usr/bin/env lua
-- ruuvi.lua - Bindings for accessing data from the RuuviTracker via the client API
-- Copyright Stæld Lakorv, 2013 <staeld@illumine.ch>
--
-- This file is part of lua-ruuvi.
--
-- lua-ruuvi is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- lua-ruuvi is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with lua-ruuvi. If not, see <http://www.gnu.org/licenses/>.

if _VERSION == "Lua 5.2" then
    -- Fix the problem that our libraries may be in a 5.1 directory
    package.path    = package.path ..";".. package.path:gsub("5%.2", "5.1")
end

-- Prerequisites
local json      = require("dkjson")
local curl      = require("cURL")
local aux       = require("helpers")
local events    = require("events")
local trackers  = require("trackers")

-- EOF
