#!/usr/bin/env lua
-- helpers.lua - Auxilliary functions for lua-ruuvi
-- Copyright Stæld Lakorv, 2013 <staeld@illumine.ch>
-- This file is part of lua-ruuvi.
-- lua-ruuvi is released under the GPLv3 - see COPYING

-- Prerequisites
local curl = require("cURL")

-- Declare module container
local aux = {}

function aux.throwError(err)
    io.stderr:write("error: ", err, "\n")
    os.exit(1)
end

function aux.connObj(server, path)
    local c = curl.easy_init()
    c:setopt_useragent(libName .."/".. libVersion)
    c:setopt_url(server .. vars.apiPath .. path)
    return c
end

-- TODO: should aux.ping() be moved to top level (ruuvi.ping()) for direct use?
function aux.ping(server)
    local pingTime = os.time(os.date("!*t"))    -- Ensure it's in UTC

    local c = aux.connObj(server, "ping")
    local f = io.tmpfile()
    c:perform({ writefunction = function(str) f:write(str) end})
    local recv = os.time(os.date("!*t"))
    local obj  = aux.readjson(f)
    f:close()
    if obj and obj.time then
        local serverTime = os.time(aux.toTimeTable(obj.time))
        local servdiff   = os.difftime(recv, serverTime)
        local lag        = os.difftime(recv, pingTime)
        print("Ping successful! Turnabout lag: " .. lag .. ", time difference: " .. servdiff)
        return true, lag, servdiff
    end
end

function aux.url_addParams(path, paramArray)
    local paramsAdded = false
    for param, value in pairs(paramArray) do
        if not paramsAdded then
            path = path .."?".. param .."=".. value
            paramsAdded = true
        else
            path = path .."&".. param .."=".. value
        end
    end
    return path
end

function aux.readjson(filehandle)
    filehandle:seek("set")
    local str = filehandle:read("*a")
    local obj, pos, err = json.decode(str)
    if err then aux.throwError(err)
    else return obj end
end

function aux.toTimeTable(str)
    local t = {}
    t.year, t.month, t.day = str:match("(%d%d%d%d)%-(%d%d)%-(%d%d)")
    t.hour, t.min, t.sec, t.off, t.offh, t.offm = str:match("T(%d%d):(%d%d):(%d%d).-([+-])(%d%d)(%d%d)")
    -- Compensate for timezones, return time in UTC
    if t.off == "+" then
        t.hour = t.hour + t.offh
        t.min  = t.min  + t.offm
    elseif t.off == "-" then
        t.hour = t.hour - t.offh
        t.min  = t.min  - t.offm
    end
    return t
end

function aux.toTimeString(t)
    os.date("!%FT%T%z", os.time(t))
end

return aux
-- EOF
