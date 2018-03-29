#!/bin/bash
echo " $(nvidia-smi -q | awk '/Fan Speed/ {print $4$5}')"
