#!/bin/bash

while true
do
    xdotool click --delay $(( (RANDOM % 75 ) + 50 )) --repeat 1 1;
done
