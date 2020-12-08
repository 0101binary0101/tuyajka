
# 
tuyashare=${1:-"/usr/share/hassio/share/tuyapower/"}
if [ ! -d "${tuyashare}" ]; then
	echo "change your the tuyashare to be something like /usr/share/hassio/share/tuyapower/ if running on HA /usr/share/hassio/share/tuyapower/ is probably accessible outside of HA docker" 
	echo "Maybe you'd like to create the /usr/share/hassio/share/tuyapower/ or specify a different directory under /usr/share/hassio/share/"
	exit 1
fi


docker run -d --restart=unless-stopped --network=host --name tuyajka --volume=${tuyashare}/:/share-tuya/:rw tuyajka
