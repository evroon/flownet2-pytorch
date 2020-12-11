#!/bin/bash

if [[ -z "${FLOWNET2_CHECKPOINTS_DIR}" ]]; then
    echo "Environment variable 'FLOWNET2_CHECKPOINTS_DIR' does not exist."
    echo "Please set it ~/.bashrc using: 'export FLOWNET2_CHECKPOINTS_DIR=/path/to/FLOWNET2_CHECKPOINTS_DIR'"
    exit 1
fi

if [[ -z "${MPI_SINTEL_DIR}" ]]; then
    echo "Environment variable 'MPI_SINTEL_DIR' does not exist."
    echo "Please set it in ~/.bashrc using: 'export MPI_SINTEL_DIR=/path/to/MPI_SINTEL_DIR'"
    exit 1
fi

sudo nvidia-docker build -t $USER/flownet2:latest .
sudo nvidia-docker run  --rm -ti \
                        --volume=$(pwd):/flownet2-pytorch:rw \
                        -v $FLOWNET2_CHECKPOINTS_DIR:/data/flownet2-checkpoints \
                        -v $MPI_SINTEL_DIR:/data/mpi-sintel \
                        --workdir=/flownet2-pytorch \
                        --ipc=host $USER/flownet2:latest \
                        /bin/bash
