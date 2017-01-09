#!/usr/bin/env bash

WINDOW=$(xdotool getactivewindow getwindowname)

if [[ $WINDOW == *"- Terminal" ]]
then
	xdotool key --clearmodifiers ctrl+shift+t
else
	xdotool key --clearmodifiers ctrl+t
fi