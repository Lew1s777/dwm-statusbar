#!/bin/bash

print_volume() {
	volume="$(amixer get Master | tail -n1 | sed -r 's/.*\[(.*)%\].*/\1/')"
	if test "$volume" -gt 0
	then
	   echo -e "${volume}"
	else
	   echo -e "Mute"
	fi
}

print_mem(){
	memfree=$(($(grep -m1 'MemAvailable:' /proc/meminfo | awk '{print $2}') /1024/1024))
	echo -e "$memfree"
}

get_battery_charging_status() {

	if $(acpi -b | grep --quiet Discharging)
	then
		echo "ð";
	else # acpi can give Unknown or Charging if charging, https://unix.stackexchange.com/questions/203741/lenovo-t440s-battery-status-unknown-but-charging
		echo "ð";
	fi
}

print_bat(){
	charge="$(awk '{ sum += $1 } END { print sum }' /sys/class/power_supply/BAT*/capacity)%"
	echo -e "${charge}"
}

print_date(){
#	date '+%Y/%m/%d %H:%M'
#	date '+%H:%M'
	date '+%m/%d-%H:%M'
}

print_cpu_temp(){
        cpu=/sys/class/hwmon/hwmon3/temp1_input
        cpu="$(($(< "$cpu") * 100 / 10000))"
        cpu="${cpu/${cpu: -1}}.${cpu: -1}"
        echo "$cpu"
}

print_gpu_temp(){
        gpu=/sys/class/hwmon/hwmon5/temp1_input
        gpu="$(($(< "$gpu") * 100 / 10000))"
        gpu="${gpu/${gpu: -1}}.${gpu: -1}Â°${gpu_temp:-C}"
        echo "$gpu"
}

#xsetroot -name "  ð¿ $(print_mem)M â¬ï¸ $vel_recv â¬ï¸ $vel_trans $(dwm_alsa) [ $(print_bat) ]$(show_record) $(print_date) "
xsetroot -name "ð¡$(print_cpu_temp)/$(print_gpu_temp)ä¸¨ð$(print_volume)ä¸¨ð¿$(print_mem)Gä¸¨$(get_battery_charging_status)[ð$(print_bat)]ä¸¨$(print_date)"

exit 0
