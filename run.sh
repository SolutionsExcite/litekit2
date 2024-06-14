#!/bin/bash

sudo docker build -t litekit2 .

sudo docker run -it --rm --privileged litekit2