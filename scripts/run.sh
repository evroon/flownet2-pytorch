#!/bin/bash

DATASET_PATH="/data/frames"
OUTPUT_PATH="/data/frames/output"
CHECKPOINT_PATH="/data/flownet2-checkpoints/FlowNet2_checkpoint.pth.tar"
DATASET_TYPE="ImagesFromFolder"
DATASET_ROOT=$DATASET_PATH

python3 main.py --inference --model FlowNet2 --save_flow \
                --inference_dataset $DATASET_TYPE \
                --inference_dataset_root $DATASET_PATH \
                --resume $CHECKPOINT_PATH \
                --save $OUTPUT_PATH

python3 -m flowiz \
                $OUTPUT_PATH/inference/run.epoch-0-flow-field/*.flo \
                -o $OUTPUT_PATH/color_coding \
                -v $OUTPUT_PATH/color_coding/video \
                -r 30

ffmpeg -i $OUTPUT_PATH/color_coding/%06d.flo.png -c:v libx264 -vf fps=30 -pix_fmt yuv420p $OUTPUT_PATH/color_coding/output.mp4

echo "Wrote output video to:"
echo $DATASET_DIR/output/color_coding/output.mp4