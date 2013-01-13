#!/usr/bin/env lua
-- trackers.lua - Tracker-related functions for lua-ruuvi
-- Copyright Stæld Lakorv, 2013 <staeld@illumine.ch>
-- This file is part of lua-ruuvi.
-- lua-ruuvi is released under the GPLv3 - see COPYING
local M = {}

function M.getList(server, idString)
    local c
    if idString then
        c = aux.connObj(server, "trackers/" .. idString)
    else
        c = aux.connObj(server, "trackers")
    end
    c:perform({ writefunction = M.handleList })
end

function M.handleList(str)
    local obj, pos, err = json.decode(str)
    if     err then aux.throwError(err)
    elseif obj and obj.trackers then
        return obj.trackers
    end
end

return M
-- EOF
