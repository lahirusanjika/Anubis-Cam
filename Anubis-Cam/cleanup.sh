#!/bin/bash
rm -f index.php index2.html index3.html ip.txt saved.ip.txt location_*.txt saved.locations.txt cam_*.png Log.log LocationLog.log LocationError.log location_debug.log .cloudflared.log current_location.txt current_location.bak
rm -rf saved_locations/*
rm -rf images/*
echo "Cleanup done."