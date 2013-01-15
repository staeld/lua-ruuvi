#!/usr/bin/env lua
-- trackers.lua - Tracker-related functions for lua-ruuvi
-- Copyright Stæld Lakorv, 2013 <staeld@illumine.ch>
-- This file is part of lua-ruuvi.
-- lua-ruuvi is released under the GPLv3 - see COPYING
local M = {}

function M.getList(server, idString, paramArray)
    local path = "trackers"
    if idString then
        path = path .."/".. idString
    end
    if paramArray then path = aux.url_addParams(path, paramArray) end
    local c = aux.connObj(server, path)
    local f = io.tmpfile()
    c:perform({ writefunction = function(str) f:write(str) end })
    local obj = aux.readjson(f)
    f:close()
    return obj.trackers
end

return M
-- EOF
