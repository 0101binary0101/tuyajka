# tuyajka
My first container for Tuya stuff for Home Assistant power reporting

In order to use this you'll need to have access to your Tuya Account and have setup a Tuya API Key and Tuya API Secret - Once you've obtained this info then you should be able to use this container to report on the plugs you have registered with things like Smartlife and anything other registered with Tuya.

Build:
 docker build -t tuyajka .

Running:
 Read and understand the run-tuyajka.sh and modify it...  it will expect you to modify it .. because HA will probably have access to a /usr/share/hassio/share/tuyapower/ folder .. so create a /usr/share/hassio/share/tuyapower/ folder and mod the script to mount onto that volume.

 then bash the script to start the container:
 ```
 bash run-tuyajka.sh
 docker ps | grep tuyajka
```
SETUP of your tuya devices
 Scan your network for Tuya devices , NOTE the second column is a Virtual Device ID - You'll need ONE of those in the tuyawiz process. Note this takes about 1 minute

   docker exec -ti tuyajka bash /local-tuya/find-local-devices.sh

 Next Generate the tuya wizard output file .... this bit is a bit manual. Use the Tuya API key and secret , and ONE of the devices from above.
```
  docker exec -ti tuyajka bash /local-tuya/get-tuyawiz.sh
```
 You have to manually copy and paste as per the instructions...
 e.g. vi /usr/share/hassio/share/tuyapower/tuya-wizard.out, the contents will look like this:
 
```
[ { name: 'Bike charger',
    id: 'xxxxxxx',
    key: 'xxxxxxxx' } ] 

```

 Then generate the index.plug file .... this will automatically go into your /share/tuyapower/ (/usr/share/hassio/share/tuyapower/) directory (or which ever volume you mount)
```
   docker exec -ti tuyajka bash /local-tuya/create-tuya-index.sh
```
 Now the /share/tuyapower/ directory should start to generate json files with your plug power contents..... if they are 0 bytes remove the entry from index.plug


 Inclusion into HA example:

 To allow access to the /share/tuyapower/ directory your configuration.yaml should include the following lines:

```
homeassistant:
  customize: !include customize.yaml
  allowlist_external_dirs:
    - /share/tuyapower
```
 To add sensors - You can manually execute the command.
   docker exec -ti tuyajka bash /local-tuya/generate-ha-senors.sh

 It should produce output that you can add to your configuration.yaml 'sensor:' attribute

example with 'sensor:'
```
 sensor:
   - platform: file
    name: plug_lounge_1_power
    value_template: "{{ value_json.power }}"
    unit_of_measurement: "power"
    file_path: /share/tuyapower/plug_lounge_1.json
    scan_interval: 60

```


The files generated and updated in /usr/share/hassio/share/tuyapower/ directory will look like this:

```
jka@ha03-deb:~/tuyajka$ cat /usr/share/hassio/share/tuyapower/plug_Bike_charger.json
{ "switch": "False", "power": 0.0, "current": 0.0, "voltage": 239.6 }
jka@ha03-deb:~/tuyajka$
```
