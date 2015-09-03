#!/bin/bash
# Copyright (c) 2015, TruSTAR Corporation Corporation. All rights reserved.
# See LICENSE.txt for full terms.

REPORTS_ENDPOINT="https://station.trustartechnology.com:8443/services/incident/reports"
AUTH_ENDPOINT="https://station.trustartechnology.com:8443/login.html"

USER="$STATION_USERNAME"
PASSWORD="$STATION_PASSWORD"

function authenticate() {
 	#echo "$@" 
 	data="username=$USER&password=$PASSWORD"
	content=$(curl -s -k -d "username=${USER}&password=${PASSWORD}" --dump-header headers ${AUTH_ENDPOINT})	
}


function getReport() {
	local report_id=$1
	local format=$2

 	#echo "$@" 

	url=${REPORTS_ENDPOINT}/${report_id}/download.$format
	content="$(curl -s -L -k -b headers ${url})"

  case $format in
    stix)
      extension="xml"
      ;;
    json)
      extension="json"
      ;;
  esac

  out_file=${report_id}.${extension}
	echo "$content" > ${out_file}
  echo "Saving exported report to ${out_file}...  "
}

function usage() {
    error "Usage: $0 <reportid> <stix|json> "
    exit 1
}

function error() {
    echo "ERROR: $@" >&2
    exit 1
}



if (( ${#@} == 0 )); then
    usage
fi

# Abort if the user's bash profile hasn't been updated to include required environment variables
if [[ -z "$STATION_USERNAME" ]]; then
	error 'Must set STATION_USERNAME environment variable' 
elif [[ -z "$STATION_PASSWORD" ]]; then
	error 'Must set STATION_PASSWORD environment variable' 
fi


echo "Requesting report $1"

authenticate

case $2 in
  stix)
    getReport $1 "stix"
    ;;
  json)
  	getReport $1 "json" 
    ;;
   *)
    getReport $1 "stix"
    ;;
esac
