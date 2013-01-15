#!/usr/bin/env lua
-- servobj.lua - Server object creation for lua-ruuvi
-- Copyright Stæld Lakorv, 2013 <staeld@illumine.ch>
-- This file is part of lua-ruuvi.
-- lua-ruuvi is released under the GPLv3 - see COPYING
local M = {}

function M.new(url)
    if type(url) ~= "string" then aux.throwError("not a string") end
    local obj = {}
    if not url:find(vars.apiPath:gsub("([%.%-%+])", "%%%1")) then
        url = url:gsub("/$", "") .. vars.apiPath
    end

    obj.url = url
    obj._c   = aux.connObj(url) -- TODO: Use this object instead of creating new ones for every function call

    function obj:ping()
        return aux.ping(self.url)
    end

    -- Events
    function obj:events(idString, paramArray)
        return events.getList(self.url, idString, paramArray)
    end
    -- Trackers
    function obj:trackers(idString, paramArray)
        print(self.url)
        return trackers.getList(self.url, idString, paramArray)
    end
    function obj:eventsFor(idString, paramArray)
        return events.getFor(self.url, idString, paramArray)
    end
    function obj:latestFor(idString, paramArray)
        return events.getLatestFor(self.url, idString, paramArray)
    end
    
    return obj
end

return M
-- EOF
