#!/bin/bash

source config.sh

docker run -it --rm \
    -p 8888:8888 \
    -v $(pwd)/notebooks:/home/jovyan/work \
    -v $(pwd)/data:/data \
    -v $(pwd)/scripts:/scripts \
    -w /scripts \
    ${image_name}:${version}
