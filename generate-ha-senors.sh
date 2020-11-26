#!bin/bash
# Jka 2020 
# simple script to generate json from /share-tuya/index.plug if it exists
#
tuyashare=${1:-"/share-tuya/"}

while read in
do
 
 outjson=`echo $in| awk -F : '{ print "plug_"$4".json" }'`
 outpower=`echo $in| awk -F : '{ print "plug_"$4"_power" }'`

cat << -EOF-
  - platform: file
    name: ${outpower}
    value_template: "{{ value_json.power }}"
    unit_of_measurement: "power"
    file_path: /share/tuyapower/${outjson}
    scan_interval: 60

-EOF-
done < <( cat  ${tuyashare}/index.plug  | sed -r '/^(\s*#|$)/d;' )


