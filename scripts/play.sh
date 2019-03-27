#!/bin/bash

# Hacks preventing sleep
setterm -powersave off -blank 0
setterm -blank 0
settern -blank off -powerdown off > /dev/tty0
clear > /dev/tty0

SERVICE='omxplayer'

if [ ! -f "$1" ]; then
	echo "File doesn't exist"
	exit 1
fi

while true; do
	if ps ax | grep -v grep | grep $SERVICE > /dev/null; then
		# Playing
		sleep 30s
	else
		$SERVICE -b -o both --vol -2000 "$1" &
	fi
done
