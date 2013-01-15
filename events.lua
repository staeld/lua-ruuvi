#!/usr/bin/env lua
-- events.lua - Functions relating to events
-- Copyright Stæld Lakorv, 2013 <staeld@illumine.ch>
-- This file is part of lua-ruuvi.
-- lua-ruuvi is released under the GPLv3 - see COPYING
local M = {}

-- TODO: Refactor these into one/several smaller functions; reuse code
function M.getList(server, idString)
    local c
    if idString then
        c = aux.connObj(server, "events/" .. idString)
    else
        c = aux.connObj(server, "events")
    end
    local f = io.tmpfile()
    c:perform({ writefunction = function(str) f:write(str) end })
    local obj = aux.readjson(f)
    f:close()
    return obj.events
end

function M.getFor(server, idString, paramArray)
    local path = "trackers/" .. idString .. "/events"
    if paramArray then path = aux.url_addParams(path, paramArray) end
    local c = aux.connObj(server, path)
    local f = io.tmpfile()
    c:perform({ writefunction = function(str) f:write(str) end })
    local obj = aux.readjson(f)
    f:close()
    return obj.events
end

function M.getLatestFor(server, idString, paramArray)
    local path = "trackers/" .. idString .. "/events/latest"
    if paramArray then path = aux.url_addParams(path, paramArray) end
    local c = aux.connObj(server, path)
    local f = io.tmpfile()
    c:perform({ writefunction = function(str) f:write(str) end })
    local obj = aux.readjson(f)
    f:close()
    return obj.events
end

return M
-- EOF
