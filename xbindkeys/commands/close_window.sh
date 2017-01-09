#!/usr/bin/env bash

WINDOW=$(xdotool getactivewindow getwindowname)

if [[ $WINDOW == *"- Terminal" ]]
then
	xdotool key --clearmodifiers ctrl+shift+w
else
	xdotool key --clearmodifiers ctrl+w
fi