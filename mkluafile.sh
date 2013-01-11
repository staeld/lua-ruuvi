#!/bin/bash
# Lazily initialise a new lua file for the project

TEXT="#!/usr/bin/env lua\n-- FILE - DESC\n-- Copyright Stæld Lakorv, 2013 <staeld@illumine.ch>\n-- This file is part of lua-ruuvi.\n-- lua-ruuvi is released under the GPLv3 - see COPYING\n\n-- EOF\n"

if [ -n "$1" ] && [ "$1" = "--help" ]; then
    echo Usage: $0 <filename> "<description>"
    exit
fi

if [ -n "$1" ]; then filename="$1"
else read -p "Filename: " filename; fi
if [ -n "$2" ]; then desc="$2"
else read -p "Description: " desc; fi

filename=${filename}.lua

if [ -e "$filename" ]; then
    echo "error: file exists"
    exit 1
fi

echo File: $filename - $desc

TEXT="${TEXT/FILE/$filename}"
TEXT="${TEXT/DESC/$desc}"

echo -e $TEXT
echo -e $TEXT > ${filename}
