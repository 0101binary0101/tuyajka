#!bin/bash
# Jka 2020 
# simple script to generate json from /share-tuya/index.plug if it exists
#
while read in
do
 echo $in
 plugname=`echo $in| awk -F : '{ print "plug_"$4".json" }'`
 PLUGID=`echo $in|awk -F : '{print $1}'`
 PLUGKEY=`echo $in|awk -F : '{print $2}'`
 PLUGIP=`echo $in|awk -F : '{print $3}'`
 PLUGVERS="3.3"
 echo "PLUGID=${PLUGID} PLUGKEY=${PLUGKEY} PLUGIP=${PLUGIP} PLUGVERS=${PLUGVERS} /local-tuya/plugjson-floats.py" 
 python3 /local-tuya/plugjson-floats.py "${PLUGID}" "${PLUGIP}" "${PLUGKEY}" "3.3"  | grep -v -- '-99' > /share-tuya/.${plugname}.new
 mv /share-tuya/.${plugname}.new /share-tuya/${plugname}
 
 echo /share-tuya/${outjson}
done < <( cat  /share-tuya/index.plug  | sed -r '/^(\s*#|$)/d;' )


