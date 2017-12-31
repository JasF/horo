#i/bin/bash

echo "pre datastore" >> /home/andreivoe/updater.txt
bash ./datastoreupdate.sh
echo "pre ttyupdate" >> /home/andreivoe/updater.txt
bash ./ttyupdate.sh

