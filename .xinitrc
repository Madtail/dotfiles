# dwm statusbar - show current date and time
#audio_volume="$(amixer get Master | grep -o '[^ ]*%[^ ]*')"
id="9"
speed=0.99
xinput set-prop $id "Coordinate Transformation Matrix" $speed, 0, 0, 0, $speed, 0, 0, 0, 1
let loop=0
while true; do
	battery_status="$(acpi)"
	audio_volume="$(amixer get Master | grep -o '[^ ]*%[^ ]*')"
	xsetroot -name "$battery_status | $audio_volume |  $(date "+%F %R")"
	let loop=$loop+1
	sleep 1
xscreensaver -no-splash & feh --bg-scale ~/images/steins1.jpg & gentoo-pipewire-launcher &
done &
exec dbus-launch --sh-syntax --exit-with-session dwm
#exec dbus-run-session dwm
