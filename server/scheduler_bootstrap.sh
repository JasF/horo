#! /bin/bash

echo "Hello sched boot" >> /home/andreivoe/scheduler.log
node ./scheduler.js >> /home/andreivoe/scheduler.log
echo "end sched boot" >> /home/andreivoe/scheduler.log
#bash ./updater_original.sh

