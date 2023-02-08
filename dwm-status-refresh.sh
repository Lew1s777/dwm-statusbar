#!/bin/sh

for temp_dir in /sys/class/hwmon/*; do
    [[ "$(< "${temp_dir}/name")" =~ (coretemp|fam15h_power|k10temp) ]] && {
        temp_dirs=("$temp_dir"/temp*_input)
        temp=${temp_dirs[0]}
	break
	}
done

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
	memfree=$(echo "scale=1;$(grep -m1 'MemAvailable:' /proc/meminfo | awk '{print $2}') /1024/1024"|bc)
	echo -e "$memfree"
}
get_battery_charging_status() { 
	if $(acpi -b | grep --quiet Discharging)
	then
		echo "🔋";
	else
		echo "🔌";
	fi
}
print_bat(){
	charge="$(awk '{ sum += $1 } END { print sum }' /sys/class/power_supply/BAT*/capacity)%"
	echo -e "${charge}"
}
print_date(){
#	date '+%Y/%m/%d/%H:%M'
	date '+%m/%d/%H:%M'
}

print_cpu_temp(){
deg="$(($(cat "$temp") * 100 / 10000))"
deg="${deg/${deg: -1}}.${deg: -1}"
echo "$deg"
}

print_cpu_freq(){
speed="$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq)"
    #speed="$(($speed / 1000))"
    speed="$(echo "scale=1;$speed / 1000000"|bc)"
echo $speed
}

xsetroot -name "🌡$(print_cpu_temp)℃丨$(print_cpu_freq)GHz丨🔊$(print_volume)丨💿$(print_mem)G丨$(get_battery_charging_status)$(print_bat)丨📆$(print_date)"
#echo "🌡$(print_cpu_temp)℃丨$(print_cpu_freq)GHz丨🔊$(print_volume)丨💿$(print_mem)G丨$(get_battery_charging_status)$(print_bat)丨$(print_date)" | ~/scripts/bin/dwm-setstatus

exit 0
