#!/bin/bash

while true
do
    xdotool click --delay $(( (RANDOM % 700 ) + 520 )) --repeat 1 1;
done
