#! /bin/bash

echo "Hello sched boot" >> /home/andreivoe/scheduler.log
cd updater
node bootstrap
echo "end sched boot" >> /home/andreivoe/scheduler.log
#bash ./updater_original.sh

