#!/bin/bash
# jka 2020
tuyashare=${1:-"/share-tuya/"}   # when inside the container
tuyalocal=${2:-"/local-tuya/"}   # when inside the container
tuyawizout="${tuyashare}/tuya-wizard.out"
if [ ! -f "${tuyawizout}" ];
then
	echo "Cant find your tuya-cli wizard output file: ${tuyawizout}"	
	echo "Issue a docker exec -ti <this-container> bash /local-tuya/cli-wiz " 
	echo "Place the the output of the above command into a file tuya-wizard.out in your mapped volume for /share-tuya/ " 
	exit
fi

echo "# Scanning your network for tuya devices looking for IPs and then matching with your tuya-cli wizard output in ${tuyawizout}"
echo "# This shouldn't take more than 5 mins"
echo "# This is your index.plug text file "  > ${tuyashare}/index.plug
echo "# <id>,<key>,<ip>,name_as_seen  with _ as spaces" >> ${tuyashare}/index.plug
while read in
do
#	echo $in
	localip=`echo $in | awk '{ print $1 }'`
	tuyaid=`echo $in | awk '{ print $2 }'`
        tuyaname=`grep -B 1 ${tuyaid} ${tuyawizout} | grep name: | awk -F \' '{ print $2 }' | sed 's/ /_/g'`
        tuyakey=`grep -A 1 ${tuyaid} ${tuyawizout}  | grep key: | awk -F \' '{ print $2 }'`
	echo "${tuyaid}:${tuyakey}:${localip}:${tuyaname}" >> ${tuyashare}/index.plug

done < <( bash ${tuyalocal}/find-local-devices.sh )

cat ${tuyashare}/index.plug


