#!/bin/bash -e

source config.sh

docker build --progress=plain -t ${image_name}:${version} .
