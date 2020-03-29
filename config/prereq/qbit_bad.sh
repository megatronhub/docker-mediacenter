#!/usr/bin/bash

# Make a list of all the torrents and grab their hash id
for hash in `curl -sS http://localhost:8282/api/v2/torrents/info | jq -r '.[].hash'`

# Loop through all the torrents and grab the hash out to get the trackeres from each
do
	# Get all the results and put it into a variable
	RESULTS=`curl -sS http://127.0.0.1:8282/api/v2/torrents/trackers?hash="$hash" | grep "Unregistered torrent"` 
	#RESULTS=`curl -sS http://127.0.0.1:8282/api/v2/torrents/trackers?hash="$hash"  | jq '.[].status' |  grep -v 0 | grep -v 2`

	# Test if results exist or not
	if test -z "$RESULTS" 
	then
		#echo "$RESULTS"
		:
	else
		echo $hash
		echo $RESULTS
		# This deletes the torrent that was found in the results
		curl -sS http://127.0.0.1:8282/api/v2/torrents/delete?hashes="$hash"\&deleteFiles=true
	fi
done