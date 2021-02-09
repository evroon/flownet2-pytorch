#!/bin/bash

COMMAND="/bin/bash"
dataset_dir=${DATASET_DIR}

while test $# -gt 0
do
    case "$1" in
        --run) COMMAND="./run.sh"
            ;;
        --run-convert) COMMAND="./run.sh --convert"
            ;;
		--dataset)
			dataset_dir="$2"
            echo $dataset_dir
			shift
			;;
    esac
    shift
done

if [[ -z "${FLOWNET2_CHECKPOINTS_DIR}" ]]; then
    echo "Environment variable 'FLOWNET2_CHECKPOINTS_DIR' does not exist."
    echo "Please set it ~/.bashrc using: 'export FLOWNET2_CHECKPOINTS_DIR=/path/to/FLOWNET2_CHECKPOINTS_DIR'"
    exit 1
fi

if [[ -z "${dataset_dir}" ]]; then
    echo "Environment variable 'DATASET_DIR' does not exist."
    echo "Please set it in ~/.bashrc using: 'export DATASET_DIR=/path/to/DATASET_DIR'"
    exit 1
fi

docker run  --gpus all --rm -ti \
            --volume=$(pwd):/flownet2-pytorch:rw \
            -v $FLOWNET2_CHECKPOINTS_DIR:/data/flownet2-checkpoints \
            -v $dataset_dir:/data/frames \
            --workdir=/flownet2-pytorch \
            --ipc=host $USER/flownet2:latest \
            $COMMAND
