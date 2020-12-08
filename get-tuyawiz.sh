#!bin/bash
echo .
echo "You will need your tuya API key and API secret"
echo .
# put the user api details in the share area, it should be protected enough from access
export HOME=/share-tuya/
tuya-cli wizard
echo "# now copy the above JSON output and place this into your /share/tuyapower/tuya-wizard.out file"
echo "# once you had done this you can create the index.plug file - docker exec -ti tuyajka bash /local-tuya/create-tuya-index.sh"
