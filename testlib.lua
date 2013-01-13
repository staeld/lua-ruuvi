#!/usr/bin/env lua
-- testlib.lua - A file to load and test the lua-ruuvi library
-- Copyright Stæld Lakorv, 2013 <staeld@illumine.ch>
-- This file is part of lua-ruuvi.
-- lua-ruuvi is released under the GPLv3 - see COPYING

local ruuvi = require("ruuvi")

ruuvi.aux.ping("http://dev-server.ruuvitracker.fi")

-- EOF
