FROM ubuntu:20.04
MAINTAINER Kingsley <jka@twiddlingthumbs.com>


ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update \
 && apt-get install -y cron \
 && apt-get install -y python3 \
 && apt-get install -y python3-pip \
 && apt-get install -y npm \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN npm i @tuyapi/cli -g

RUN touch /var/log/cron.log
RUN python3 -m pip install pycryptodome \ 
 && python3 -m pip install tinytuya \
 && python3 -m pip install tuyapower

RUN mkdir /share-tuya
RUN mkdir /local-tuya
COPY plugjson-floats.py /local-tuya/
RUN chmod +x /local-tuya/plugjson-floats.py
COPY scan_plugs.sh /local-tuya/
RUN chmod +x /local-tuya/scan_plugs.sh
COPY crontab-scan /local-tuya/
COPY find-local-devices.sh /local-tuya/
RUN chmod +x /local-tuya/find-local-devices.sh
COPY create-tuya-index.sh /local-tuya/
RUN chmod +x /local-tuya/create-tuya-index.sh
COPY get-tuyawiz.sh /local-tuya/ 
RUN chmod +x /local-tuya/get-tuyawiz.sh
COPY generate-ha-senors.sh /local-tuya/
RUN chmod +x /local-tuya/generate-ha-senors.sh

RUN crontab /local-tuya/crontab-scan

ENTRYPOINT cron start && tail -f /var/log/cron.log
