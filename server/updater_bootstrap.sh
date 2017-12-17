#!/bin/bash
echo "bootstrap.1" >> /home/andreivoe/blogs.txt
bash -c "sleep 15 && while true; do /home/andreivoe/serverscripts/updater.sh ; sleep 86400; done"
