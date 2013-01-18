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
    obj._c  = aux.connObj(url)

    obj._c:setopt_useragent(libName .."/".. libVersion)

    function obj:ping()
        return aux.ping(self)
    end

    -- Events
    function obj:events(idString, paramArray)
        return events.getList(self, idString, paramArray)
    end
    -- Trackers
    function obj:trackerId(name)
        return trackers.getId(self, name)
    end
    function obj:trackerCode(id)
        return trackers.getCode(self, id)
    end
    function obj:trackerName(id)
        return trackers.getName(self, id)
    end
    function obj:trackers(idString, paramArray)
        return trackers.getList(self, idString, paramArray)
    end
    function obj:eventsFor(idString, paramArray)
        return events.getFor(self, idString, paramArray)
    end
    function obj:latestFor(idString, paramArray)
        return events.getLatestFor(self, idString, paramArray)
    end
    
    return obj
end

return M
-- EOF
