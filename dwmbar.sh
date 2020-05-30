#!/bin/bash

# Prints out the CPU load percentage

get_load()
{
	local PREFIX=' '
	# Get the first line with aggregate of all CPUs
	cpu_last=($(head -n1 /proc/stat))
	cpu_last_sum="${cpu_last[@]:1}"
	cpu_last_sum=$((${cpu_last_sum// /+}))

	sleep 0.05

	cpu_now=($(head -n1 /proc/stat))
	cpu_sum="${cpu_now[@]:1}"
	cpu_sum=$((${cpu_sum// /+}))

	cpu_delta=$((cpu_sum - cpu_last_sum))
	cpu_idle=$((cpu_now[4]- cpu_last[4]))
	cpu_used=$((cpu_delta - cpu_idle))
	cpu_usage=$((100 * cpu_used / cpu_delta))

	# Keep this as last for our next read
	cpu_last=("${cpu_now[@]}")
	cpu_last_sum=$cpu_sum

	echo "$PREFIX$cpu_usage%"
	#printf "$PREFIX$cpu_usage"
}

# Gets temperature of the CPU
# Dependencies: lm_sensors
get_cputemp()
{
	local PREFIX=' '
	local FIRE=' '

	local WARNING_LEVEL=80
	# CPU_T=$(cat /sys/devices/platform/coretemp.0/hwmon/hwmon?/temp2_input)
	# CPU_TEMP=$(expr $CPU_T / 1000)

	CPU_TEMP="$(sensors | grep temp1 | awk 'NR==1{gsub("+", " "); gsub("\\..", " "); print $2}')"

	if [ "$CPU_TEMP" -ge $WARNING_LEVEL ]; then
		PREFIX="$FIRE$PREFIX"
	fi

	echo "$PREFIX$CPU_TEMP°C"
}

# Prints out the date
get_date()
{
	local PREFIX=' '
	echo "$PREFIX$(date '+%d-%m-%y (%a)')"
}

# Prints out the current down network traffic in MB

get_down_traffic()
{
	local PREFIX=' '
	local RECIEVE1=0
	local RECIEVE2=0

	local IFACES=$(ip -o link show | awk -F': ' '{print $2}')
	for IFACE in $IFACES; do
	if [ $IFACE != "lo" ]; then
	    RECIEVE1=$(($(ip -s -c link show $IFACE | tail -n3 | head -n 1 | cut -d " " -f5) + $RECIEVE1))
	fi
	done

	sleep 1

	local IFACES=$(ip -o link show | awk -F': ' '{print $2}')
	for IFACE in $IFACES; do
	if [ $IFACE != "lo" ]; then
	    RECIEVE2=$(($(ip -s -c link show $IFACE | tail -n3 | head -n 1 | cut -d " " -f5) + $RECIEVE2))
	fi
	done

	#echo "$PREFIX$(expr $(expr $RECIEVE2 - $RECIEVE1 ) / 1000)KB/s"
	printf "$PREFIX$(expr $(expr $RECIEVE2 - $RECIEVE1 ) / 1000)KB/s"
}

# Prints out the current up network traffic in MB
get_up_traffic()
{
	local PREFIX=' '
	local TRANSMIT1=0
	local TRANSMIT2=0

	local IFACES=$(ip -o link show | awk -F': ' '{print $2}')
	for IFACE in $IFACES; do
	if [ $IFACE != "lo" ]; then
	    TRANSMIT1=$(($(ip -s -c link show $IFACE | tail -n1 | cut -d " " -f5) + TRANSMIT1))
	fi
	done

	sleep 1

	IFACES=$(ip -o link show | awk -F': ' '{print $2}')
	for IFACE in $IFACES; do
	if [ $IFACE != "lo" ]; then
	    TRANSMIT2=$(($(ip -s -c link show $IFACE | tail -n1 | cut -d " " -f5) + TRANSMIT2))
	fi
	done

	#echo "$PREFIX$(expr $(expr $TRANSMIT2 - $TRANSMIT1) / 1000)KB/s"
	printf "$PREFIX$(expr $(expr $TRANSMIT2 - $TRANSMIT1) / 1000)KB/s"
}

# Prints the total ram and used ram in Mb
get_ram()
{
	local PREFIX=' '
	local TOTAL_RAM=$(free -mh --si | awk  {'print $2'} | head -n 2 | tail -1)
	local USED_RAM=$(free -mh --si | awk  {'print $3'} | head -n 2 | tail -1)
	local MB="MB"

	#echo "$PREFIX$USED_RAM/$TOTAL_RAM"
	printf "$PREFIX$USED_RAM/$TOTAL_RAM"
}

