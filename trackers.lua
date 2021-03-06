#!/usr/bin/env lua
-- trackers.lua - Tracker-related functions for lua-ruuvi
-- Copyright Stæld Lakorv, 2013 <staeld@illumine.ch>
-- This file is part of lua-ruuvi.
-- lua-ruuvi is released under the GPLv3 - see COPYING
local M = {}

-- trackers.getList(): get trackers, optionally narrowed by ids
function M.getList(servobj, idString, paramArray)
    local path = "trackers"
    if idString then
        path = path .."/".. idString
    end
    if paramArray then path = aux.url_addParams(path, paramArray) end
    -- local c = aux.connObj(server, path)
    local c = servobj._c
    c:setopt_url(servobj.url .. path)
    local f = io.tmpfile()
    c:perform({ writefunction = function(str) f:write(str) end })
    local obj = aux.readjson(f)
    f:close()
    return obj.trackers
end

-- TODO: Refactor/fix these

-- trackers.getId(): get the id of a tracker with given code/name
function M.getId(servobj, name, paramArray)
    local list = M.getList(servobj, nil, paramArray)
    for i, t in ipairs(list) do
        if t.tracker_code == name then return t.id end
    end
    -- Try again, with real names instead of id-strings
    for i, t in ipairs(list) do
        if t.name == name then return t.id end
    end
    return nil
end
-- trackers.getCode(): return tracker_code for a single id
function M.getCode(servobj, id, paramArray)
    local list = M.getList(servobj, nil, paramArray)
    return M.handleGet(list, "tracker_code", id)
end
-- trackers.getName(): return tracker's name for a single id
function M.getName(servobj, id, paramArray)
    local list = M.getList(servobj, nil, paramArray)
    return M.handleGet(list, "name", id)
end

-- trackers.handleGet(): auxilliary function to handle lists
function M.handleGet(list, item, id)
    for i, t in ipairs(list) do
        if t.id == id then return t[item] end
    end

end

return M
-- EOF
