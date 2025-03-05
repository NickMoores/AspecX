#!/bin/sh
until pactl info >/dev/null 2>&1; do
    sleep 0.5
done

pactl load-module module-null-sink sink_name=ChromeAudio sink_properties=device.description=ChromeAudio
pactl set-default-sink ChromeAudio
pactl set-default-source ChromeAudio.monitor