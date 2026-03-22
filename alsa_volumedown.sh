#!/bin/sh

/etc/init.d/alsasound status &>/dev/null && amixer -c 1 -q sset Master 2%-  
