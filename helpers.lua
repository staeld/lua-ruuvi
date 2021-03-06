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
    error(err)
    --io.stderr:write("error: ", err, "\n")
    --os.exit(1)
end

-- aux.connObj(): create a new curl connection object with library useragent
function aux.connObj(url, path)
    path = path or ""
    local c = curl.easy_init()
    c:setopt_useragent(libName .."/".. libVersion)
    c:setopt_url(url .. path)
    return c
end

-- Ping server via the API
function aux.ping(servobj)
    local pingTime = os.time(os.date("!*t"))    -- Ensure it's in UTC

    local c = servobj._c        -- Clone the server's connection object
    c:setopt_url(servobj.url .. "ping")

    local f = io.tmpfile()      -- Write api output to tmpfile
    c:perform({ writefunction = function(str) f:write(str) end })
    local recv = os.time(os.date("!*t"))
    local obj  = aux.readjson(f)
    f:close()
    if obj and obj.time then
        -- Calculate ping and time difference
        local serverTime = os.time(aux.toTimeTable(obj.time))
        local servdiff   = os.difftime(recv, serverTime)
        local lag        = os.difftime(recv, pingTime)
        print("DEBUG Ping successful! Turnabout lag: " .. lag .. ", time difference: " .. servdiff)
        return true, lag, servdiff
    else
        print("DEBUG Ping did not output proper response!")
    end
end

-- aux.url_addParams(): add parametres to the API path
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

-- aux.readjson(): reads and parses json from a temporary file
function aux.readjson(filehandle)
    filehandle:seek("set")
    local str = filehandle:read("*a")
    local obj, pos, err = json.decode(str)
    if err then aux.throwError(err)
    else return obj end
end

-- aux.toTimeTable(): creates a standard time table from a string
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

-- aux.toTimeString(): creates a standard time string from a table
function aux.toTimeString(t)
    os.date("!%FT%T%z", os.time(t))
end

return aux
-- EOF
