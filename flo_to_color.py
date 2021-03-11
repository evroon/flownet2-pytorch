#!/usr/bin/env python

import flow_vis
import numpy as np
import glob
import argparse
import cv2
import os

def read_flow(filename):
    TAG_FLOAT = 202021.25

    with open(filename, 'rb') as f:
        flo_number = np.fromfile(f, np.float32, count=1)[0]
        assert flo_number == TAG_FLOAT, 'Flow number %r incorrect. Invalid .flo file' % flo_number

        w = np.fromfile(f, np.int32, count=1)[0]
        h = np.fromfile(f, np.int32, count=1)[0]
        data = np.fromfile(f, np.float32, count=2*w*h)

        return np.resize(data, (int(h), int(w), 2))


parser = argparse.ArgumentParser(description='Process some integers.')
parser.add_argument('input', type=str, help='input .flo files')
parser.add_argument('output', type=str, help='output .png files')
args = parser.parse_args()
input = args.input
output = args.output
images = glob.glob(input)
images.sort()

for i, img_path in enumerate(images):
    name = os.path.basename(img_path)
    img = read_flow(img_path)
    img = flow_vis.flow_to_color(img, convert_to_bgr=True)
    cv2.imwrite(output + f'/{i:06d}.png', img)
