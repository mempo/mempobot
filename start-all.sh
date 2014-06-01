#/bin/bash

source ./colors.sh

echo -e "${light_blue}Starting irc bot ${NC}"
bash ./start-irc.sh

sleep 4
echo -e "${light_blue}Starting event loop ${NC}"

nohup bash cron-loop.sh &

echo "All should be now running in background..."

ps aux | grep ii

