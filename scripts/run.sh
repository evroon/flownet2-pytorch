#!/bin/bash

MPI_SINTEL_PATH="/data/mpi-sintel"
OUTPUT_PATH="/data/mpi-sintel/output"
CHECKPOINT_PATH="/data/flownet2-checkpoints/FlowNet2_checkpoint.pth.tar"

python3 main.py --inference --model FlowNet2 --save_flow \
                --inference_dataset MpiSintelClean \
                --inference_dataset_root $MPI_SINTEL_PATH/training \
                --resume $CHECKPOINT_PATH \
                --save $MPI_SINTEL_PATH/output

python3 -m flowiz \
                $OUTPUT_PATH/inference/run.epoch-0-flow-field/*.flo \
                -o $OUTPUT_PATH/color_coding \
                -v $OUTPUT_PATH/color_coding/video \
                -r 30

ffmpeg -i $OUTPUT_PATH/color_coding/%06d.flo.png -c:v libx264 -vf fps=30 -pix_fmt yuv420p $OUTPUT_PATH/color_coding/output.mp4
