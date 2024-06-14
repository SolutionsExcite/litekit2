#!/bin/bash

sudo docker build -t litekit2 .
#podman build -t litekit2 -f Dockerfile ./

sudo docker run -it --rm --privileged litekit2
#podman run -it --rm --privileged litekit2