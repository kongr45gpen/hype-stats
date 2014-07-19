#!/usr/bin/bash

echo -n "`date -uR` "
curl -sH 'Accept: application/vnd.twitchtv.v2+json' -X GET https://api.twitch.tv/kraken/streams/jl2579 | python -mjson.tool | grep viewers | awk '{print $2}'
