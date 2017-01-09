#!/usr/bin/env bash

WINDOW=$(xdotool getactivewindow getwindowname)

if [[ $WINDOW == *"- Terminal" ]]
then
	xdotool key --clearmodifiers ctrl+shift+f
else
	xdotool key --clearmodifiers ctrl+f
fi