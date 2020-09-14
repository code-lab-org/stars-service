#!/bin/bash

docker run \
       -it \
       --rm \
       -p 8080:8080 \
       --network="host" \
       -v $(pwd)/workspace:/workspace \
       -w /workspace \
       stars-service
       
