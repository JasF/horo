#! /bin/bash

echo "HelloDSU" >> /home/andreivoe/dsu.txt
node /home/andreivoe/serverscripts/datastoreupdate.js >> /home/andreivoe/datastoreupdate.log

