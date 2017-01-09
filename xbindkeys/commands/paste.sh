#!/usr/bin/env bash

WINDOW=$(xdotool getactivewindow getwindowname)

if [[ $WINDOW == *"- Terminal" ]]
then
	xdotool key --clearmodifiers ctrl+shift+v
else
	xdotool key --clearmodifiers ctrl+v
fi