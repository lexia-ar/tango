#! /bin/bash

# Build and run the image
chmod +x run_docker.sh
./run_docker.sh

# Install dependencies
pip install -r requirements.txt


# (optional) Set HF_HOME
export HF_HOME=/mnt/a/tango/cache

