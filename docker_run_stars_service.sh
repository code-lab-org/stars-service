#!/bin/bash

docker run -it -p 8080:8080 --network="host" \
       -v $(pwd)/workspace:/workspace \
       aobrien200/stars-service
       
