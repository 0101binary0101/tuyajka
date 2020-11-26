#!/bin/bash
# Jka 2020
# This needs tuyapower modules to be installed.. in the container :) or in the outside OS if you like 
python3 -m tuyapower | awk '{ \
 if (index($0,"FOUND Device")) \
 {  \
	ipaddr = sprintf("%s",$NF); \
 } \
 if ( index($0,"ID =") ) \
 { \
	split($3,junk,","); \
	ID = sprintf("%s",junk[1]); \
	print ipaddr" "ID; \
} \
}'

