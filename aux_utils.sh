#!/bin/bash

#######################################
#   Filename: aux_utils.sh            #
#   Nedko Stefanov Nedkov             #
#   nedko.stefanov.nedkov@gmail.com   #
#   June 2016                         #
#######################################

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

declare -a FLAGS=(
1 # (1) show options

0 # (2) start up
0 # (3) back up
0 # (4) delete trailing whitespaces of specified file

### WHEN ADDING NEW FUNCTIONALITY TOUCH HERE ###
)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

declare -A colors
colors["red"]="\e[0;31m"
colors["blue"]="\e[00;36m"
colors["dark_green"]="\e[00;32m"
colors["yellow"]="\e[01;33m"

function print_and_exit() {
	echo -e "${colors[$1]}$2\e[00m"
	exit $3
}

function print() {
	if (( $# == 2 )); then
		echo -e "${colors[$1]}$2\e[00m"
	else
		echo -e $1
	fi
}

function print_warning() {
	print "red" "\nATTENTION: $1 Press Enter to continue or CTRL-C to exit:"
	read input
}

if (( $# > 0 )); then
	declare -a FLAGS=(0 0 0 0) ### WHEN ADDING NEW FUNCTIONALITY TOUCH HERE ###
	for arg do
   		case $arg in
    		1)   ((FLAGS[0]=1));;
    		2)   ((FLAGS[1]=1));;
			3)   ((FLAGS[2]=1));;
    		4)   ((FLAGS[3]=1));;
	       ### WHEN ADDING NEW FUNCTIONALITY TOUCH HERE ###
   		esac
	done
fi

######################################################################################################
# show options

function show_options() {
	print "blue" "\n*** Showing options ***"
	print "(1) show options"
	print "(2) start up"
	print "(3) back up"
	print "(4) delete trailing whitespaces of specified file\n"
	### WHEN ADDING NEW FUNCTIONALITY TOUCH HERE ###
}

######################################################################################################
# start up

function start_up() {
	print "blue" "\n*** Starting up ***"
	wmctrl -n 8

	mate-terminal --maximize -e 'htop' --tab -e 'sudo apt-get update' --tab &
	icedove &
	sleep 1
	pluma ~/Desktop/wenn_nicht_jetzt_wann_dann.txt &
	/opt/google/chrome/chrome &
	sleep 3

	wmctrl -r terminal -t 0
	wmctrl -r icedove -t 0
	wmctrl -r pluma -t 0
	wmctrl -r chrome -t 1

	wmctrl -s 0
}

######################################################################################################
# do a back up

function back_up() {
	back_up_folder_path="/media/back_up/Linux/back_up"
	FILES_TO_BACK_UP=("Desktop:$back_up_folder_path"
			          "Documents:$back_up_folder_path"
			          "Downloads:$back_up_folder_path"
			          "Dropbox:$back_up_folder_path"
			          "Packages:$back_up_folder_path"
					  "Pictures:$back_up_folder_path"
					  "Repositories:$back_up_folder_path"
					  "Scripts:$back_up_folder_path"
					  "emails:$back_up_folder_path")

	print "blue" "\n*** Doing a back up ***"
	rm -rf "$back_up_folder_path/Desktop"
	rm -rf "$back_up_folder_path/Downloads"
	rm -rf "$back_up_folder_path/Dropbox"
	rm -rf "$back_up_folder_path/Packages"
	rm -rf "$back_up_folder_path/Pictures"
	rm -rf "$back_up_folder_path/Repositories"
	rm -rf "$back_up_folder_path/Scripts"
	rm -rf "$back_up_folder_path/emails"
	cp -r .icedove emails
	for file in ${FILES_TO_BACK_UP[@]}; do
		key="${file%%:*}"
		value="${file##*:}"
		print "dark_green" "\nBacking up file: $key\n"
		rsync -rltDvh --exclude=".*" $key $value   # to exclude hidden files add: --exclude=".*"
	done
	rm -rf emails
}

######################################################################################################
# delete trailing whitespaces of specified file

function delete_trail_whitespaces_specif_file() {
	filename=$1
	if [[ $1 == ?(-)+([0-9.]) ]]; then
		print "Give the name of the file:"
		read filename
		if [ -z  $filename ]; then
			print_and_exit "red" "error: must specify the name of the file" 1
		fi
	fi
	print "blue" "\n*** Deleting trailing whitespaces from file: $filename ***"
	sed -i '' -e's/[ \t]*$//' $filename >& /dev/null
}

######################################################################################################



if (( FLAGS[0] == 1 )); then
	show_options
fi

if (( FLAGS[1] == 1 )); then
	start_up
fi

if (( FLAGS[2] == 1 )); then
	back_up
fi

if (( FLAGS[3] == 1 )); then
	delete_trail_whitespaces_specif_file ${@:$#}
fi

### WHEN ADDING NEW FUNCTIONALITY TOUCH HERE ###
