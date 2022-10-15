#!bin/bash
# Jka 2020/2022
# simple script to generate json from /share-tuya/index.plug if it exists
# 2022 - Test IP Address and Tuya port (6668) for connectivity pre-flight check
#
TUYAPORT="6668"
while read in
do
 echo $in
 plugname=`echo $in| awk -F : '{ print "plug_"$4".json" }'`
 PLUGID=`echo $in|awk -F : '{print $1}'`
 PLUGKEY=`echo $in|awk -F : '{print $2}'`
 PLUGIP=`echo $in|awk -F : '{print $3}'`
 PLUGVERS="3.3"
 # Pre-flight check
 timeout 1 bash -c "</dev/tcp/${PLUGIP}/${TUYAPORT}" 2>/dev/null
 if [ "$?" == "0" ];then
    echo "PLUGID=${PLUGID} PLUGKEY=${PLUGKEY} PLUGIP=${PLUGIP} PLUGVERS=${PLUGVERS} /local-tuya/plugjson-floats.py" 
    python3 /local-tuya/plugjson-floats.py "${PLUGID}" "${PLUGIP}" "${PLUGKEY}" "3.3"  | grep -v -- '-99' > /share-tuya/.${plugname}.new
    mv /share-tuya/.${plugname}.new /share-tuya/${plugname}
 else
    echo "${plugname} ${PLUGIP} port ${TUYAPORT} not reachable in pre-flight check"
    echo '{ "switch": "False", "power": 0.0, "current": 0.0, "voltage": 236.7 }' > /share-tuya/.${plugname}.new
    mv /share-tuya/.${plugname}.new /share-tuya/${plugname}
 fi

# echo /share-tuya/${outjson}
done < <( cat  /share-tuya/index.plug  | sed -r '/^(\s*#|$)/d;' )


