#!/bin/bash
omxplayer -o both /home/pi/fireplace/sounds/$1/`ls /home/pi/fireplace/sounds/$1/ | sort -R | tail -1`
