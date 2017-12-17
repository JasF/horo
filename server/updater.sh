#i/bin/bash

echo "pre datastore" >> /home/andreivoe/updater.txt
bash /home/andreivoe/serverscripts/datastoreupdate.sh
echo "pre ttyupdate" >> /home/andreivoe/updater.txt
bash /home/andreivoe/serverscripts/ttyupdate.sh

