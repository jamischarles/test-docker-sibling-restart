#!/bin/sh

# 1st param is json
# 2nd param is key to extract
function getjsonval {
  # echo "\$1 $1"
  # echo "\$2 $2"
  temp=`echo $1 | sed 's/\\\\\//\//g' | sed 's/[{}]//g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g' | sed 's/[\,]/ /g' | sed 's/\"//g' | grep -w $2 | cut -d":" -f2| sed -e 's/^ *//g' -e 's/ *$//g'`
  echo ${temp##*|}
}

# From inside the container:
# - sleep for 10 seconds
# - call the parent docker process via the docker domain socket
# - use the docker API to
# 	1) find the ID of the docker container we want
#   2) restart ^ container in X seconds


APP_NAME=little_brother

# call the parent docker process via the docker unix socket and use the API to find any running container with
# the following label: com.docker.compose.service=little_brother (you can see these when you inspect that container)
json=$(curl --unix-socket /var/run/docker.sock -gG -X GET http://v1.30/containers/json \
  --data-urlencode 'filters={"label": {"com.docker.compose.service='$APP_NAME'": true}}')

echo "json: $json"

# extract the container ID from json response
containerID=$(getjsonval "$json" "Id")

# echo $containerID
echo "Restarting containerID: $containerID"

# restart the container in 5 seconds
curl --unix-socket /var/run/docker.sock -X POST http://v1.30/containers/${containerID}/restart?t=5


# sleep just to keep the container running
sleep 500
