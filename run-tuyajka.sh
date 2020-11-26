
# 
echo "change your the tuyashare to be something like /share/tuyapower/ if running on HA /share is probably accessible outside of HA docker" 
tuyashare="${1:-"/share/tuyapower/"}"

docker run -d --restart=unless-stopped --network=host --name tuyajka --volume=${tuyashare}:/share-tuya/:rw tuyajka
