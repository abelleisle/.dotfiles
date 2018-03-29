#!/bin/bash
echo " $(nvidia-smi -q | awk '/GPU Current Temp/ {print $5}')°C"
#echo "$(nvidia-settings -t -q [GPU:0]/GPUCoreTemp)°C"

