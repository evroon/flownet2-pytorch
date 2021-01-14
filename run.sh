#!/bin/bash

DATASET_PATH="/data/frames"
OUTPUT_PATH="/data/frames/output"
CHECKPOINT_PATH="/data/flownet2-checkpoints/FlowNet2_checkpoint.pth.tar"
DATASET_TYPE="ImagesFromFolder"
OUTPUT_VIDEO_PATH=$OUTPUT_PATH/flownet2.mp4

while test $# -gt 0
do
    case "$1" in
        --convert) mkdir -p $DATASET_PATH/extracted_images && ffmpeg -i $DATASET_PATH/*.mp4 $DATASET_PATH/extracted_images/image_%05d.png && DATASET_PATH=$DATASET_PATH/extracted_images
            ;;
    esac
    shift
done

DATASET_PATH=$DATASET_PATH/extracted_images

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

ffmpeg -r 30 -i $OUTPUT_PATH/color_coding/%06d.flo.png -c:v libx264 -yvf fps=30 -pix_fmt yuv420p $OUTPUT_VIDEO_PATH

echo "Wrote output video to:" $OUTPUT_VIDEO_PATH
