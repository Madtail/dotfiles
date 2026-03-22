#!/bin/sh

/etc/init.d/alsasound status &>/dev/null &&
{
[ ! $(amixer get Master | grep -i off) ] &&
amixer -c 1 -q sset Master mute || amixer -c 1 -q sset Master unmute
}
