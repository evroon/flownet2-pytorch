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

python3 main.py --inference --model FlowNet2 --save_flow \
                --inference_dataset $DATASET_TYPE \
                --inference_dataset_root $DATASET_PATH \
                --resume $CHECKPOINT_PATH \
                --save $OUTPUT_PATH

echo 'Converting .flo files to RGB images...'
mkdir -p $OUTPUT_PATH/color_coding
python3.6 flo_to_color.py "$OUTPUT_PATH/inference/run.epoch-0-flow-field/*.flo" "$OUTPUT_PATH/color_coding"

echo 'Building video from flow frames...'
ffmpeg -r 30 -i $OUTPUT_PATH/color_coding/%06d.png -c:v libx264 -vf fps=30 -pix_fmt yuv420p $OUTPUT_VIDEO_PATH -y

echo "Wrote output video to:" $OUTPUT_VIDEO_PATH
