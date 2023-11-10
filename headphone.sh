#!/usr/local/bin/bash


######################################
#            config  	             # 
######################################
#set -x
bt_dev_name="headphone"
######################################
#            Functions               #
######################################
function message_wait(){
	local message=$1
	read -p "$message"
}

function check_root(){
	if ! [ "$(id -u)" -eq 0 ]                                                                       
		then                                                                                            
			echo "Please re-execute again as root."                                                       
  			exit 1                                                                                        
	fi 
}

function kill_zombies(){
	if ! [ $(ps aux | grep -v grep | grep -c virtual_oss) == 0 ]; then
		echo "..................................................."
		echo "looks like virtual_oss is running, killing it"
		echo "..................................................."
		killall virtual_oss
		sysctl hw.snd.basename_clone=1
	fi
}

function connect(){
	echo "--------------------------------------------------------------------------------------------------------"
	echo "creating oss device"
	echo "If you see message like (Could not open SDP)  that means you need to pair your headphone first."
	echo "If you see message like (Could not create CUSE DSP device) that means the virtual_oss process it running"
	echo "---------------------------------------------------------------------------------------------------------"
	/usr/local/sbin/virtual_oss -T /dev/sndstat -C 2 -c 2 -r 48000 -b 16 -s 20ms -P /dev/bluetooth/$bt_dev_name -R /dev/null -w vdsp.ctl -d dsp -l mixer&
}


#######################################
#            Algorithm                #
#######################################

check_root
kill_zombies
message_wait "Turn on your bluetooth headphone and wait for it to connect then press any key."
connect
message_wait "Press any key to disconnect and restore audio to speakers."
kill_zombies
message_wait "Bye."

# Copyright 2023 Dr Amr Osman, Consultant of cardiology
# BSD 3 Clause 
