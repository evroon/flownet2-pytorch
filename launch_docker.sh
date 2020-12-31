#!/bin/bash

if [[ -z "${FLOWNET2_CHECKPOINTS_DIR}" ]]; then
    echo "Environment variable 'FLOWNET2_CHECKPOINTS_DIR' does not exist."
    echo "Please set it ~/.bashrc using: 'export FLOWNET2_CHECKPOINTS_DIR=/path/to/FLOWNET2_CHECKPOINTS_DIR'"
    exit 1
fi

if [[ -z "${DATASET_DIR}" ]]; then
    echo "Environment variable 'DATASET_DIR' does not exist."
    echo "Please set it in ~/.bashrc using: 'export DATASET_DIR=/path/to/DATASET_DIR'"
    exit 1
fi

COMMAND="/bin/bash"

while test $# -gt 0
do
    case "$1" in
        --run) COMMAND="scripts/run.sh"
            ;;
        --install) COMMAND="./install.sh"
            ;;
    esac
    shift
done

sudo nvidia-docker run  --rm -ti \
                        --volume=$(pwd):/flownet2-pytorch:rw \
                        -v $FLOWNET2_CHECKPOINTS_DIR:/data/flownet2-checkpoints \
                        -v $DATASET_DIR:/data/frames \
                        --workdir=/flownet2-pytorch \
                        --ipc=host $USER/flownet2:latest \
                        $COMMAND
