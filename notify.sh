#!/bin/bash -e 

# startirc.sh must be executed!!! 
# irc  
pwd

irc_conf_file="conf.my/irc.conf"
source $irc_conf_file

echo "$@" > "$BASEDIR/$HOST/#mempo/in" & 

# FMS 
./send_nttp_fms.sh "$@" || { echo "FMS failed!" ; exit 2; }




