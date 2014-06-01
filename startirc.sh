#!/bin/bash

light_red='\e[1;31m' 
NC='\e[0m' # No Color

irc_conf_file="irc.conf"

# Config file exist?
if [[ ! -r "$irc_conf_file" ]] ; then  
	echo -e "${light_red}Can not find conf_file $conf_file ${NC}"
	exit 1

fi 


all_conf=$(cat $irc_conf_file | sed '/^$/d' | sed  '/^#/ d')

source $irc_conf_file

#BASEDIR=$(echo "$all_conf" |  awk '{ print $1 }')
#HOST=$(echo "$all_conf" |  awk '{ print $2 }')  
#PORT=$(echo "$all_conf" |  awk '{ print $3 }')

# ii package installed?
if ! which ii >/dev/null  ; then
    echo -e "${light_red}Package ii must be installed!!${NC}"
	exit 2
fi



killall ii &> /dev/null

set -x
nohup bash ./ii_forever.sh -f "$HOSTNAME" -n mempobot -i "$BASEDIR/" -s "$HOST" -p "$PORT" &
set +x

echo "sleep"
sleep 15
echo "joining"
echo "/JOIN #mempo" > "$BASEDIR/$HOST/in"

echo "done"
sleep 2
#echo "Showing out"
#cat "$BASEDIR/$HOST/out"

echo "All done" 
exit 0

