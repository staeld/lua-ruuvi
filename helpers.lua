#!/usr/bin/env lua
-- helpers.lua - Auxilliary functions for lua-ruuvi
-- Copyright Stæld Lakorv, 2013 <staeld@illumine.ch>
-- This file is part of lua-ruuvi.
-- lua-ruuvi is released under the GPLv3 - see COPYING

-- Prerequisites
local curl = require("cURL")

-- Declare module container
local M = {}

function M.throwError(err)
    io.stderr:write("error: ", err, "\n")
    os.exit(1)
end

function M.connObj(server, path)
    local c = curl.easy_init()
    c:setopt_useragent(libName .."/".. libVersion)
    c:setopt_url(server .. apiPath .. path)
    return c
end

-- TODO: should aux.ping() be moved to top level (ruuvi.ping()) for direct use?
function M.ping(server)
    local c = M.connObj(server, "ping")
    c:perform({ writefunction = M.handlePing })
end

function M.handlePing(str)
    -- We expect the ping response to be json
    local obj, pos, err = json.decode(str)
    if     err then M.throwError(err)
    elseif obj and obj.time then
        local now      = os.time(os.date("!*t"))
        local pingTime = os.time(M.toTimeTable(obj.time))
        local diff     = os.difftime(now, pingTime)
        -- TODO: Do something with the ping info?
        -- FIXME: This return is not received by anything
        return diff, obj['server-software']
    end
end

function M.addParams(path, paramArray)
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

function M.readjson(filehandle)
    local str = filehandle:read("*a")
    local obj, pos, err = json.decode(str)
    if err then M.throwError(err)
    else return obj end
end

function M.toTimeTable(str)
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

function M.toTimeString(t)
    os.date("!%FT%T%z", os.time(t))
end

return M
-- EOF
