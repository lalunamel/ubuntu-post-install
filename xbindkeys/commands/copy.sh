#!/usr/bin/env bash

WINDOW=$(xdotool getactivewindow getwindowname)

if [[ $WINDOW == *"- Terminal" ]]
then
	xdotool key --clearmodifiers ctrl+shift+c
else
	xdotool key --clearmodifiers ctrl+c
fi