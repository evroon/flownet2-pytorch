# TODO: Use Ubuntu 20.04, but this will give compile errors in the resample2d package.
FROM nvidia/cuda:9.0-cudnn7-devel-ubuntu16.04

ARG DEBIAN_FRONTEND=noninteractive

# basic packages
RUN apt-get -y update && apt-get -y upgrade && \
        apt-get install -y sudo cmake g++ gfortran \
        libhdf5-dev pkg-config build-essential \
        wget curl git htop tmux vim ffmpeg rsync openssh-server \
        python3 python3-dev libpython3-dev nano software-properties-common && \
        apt-get -y autoremove && apt-get -y clean && apt-get -y autoclean && \
        rm -rf /var/lib/apt/lists/*

RUN apt-add-repository ppa:deadsnakes/ppa && apt-get -y update && apt-get install -y python3.6

# cuda path
ENV CUDA_ROOT /usr/local/cuda
ENV PATH $PATH:$CUDA_ROOT/bin
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:$CUDA_ROOT/lib64:$CUDA_ROOT/lib:/usr/local/nvidia/lib64:/usr/local/nvidia/lib
ENV LIBRARY_PATH /usr/local/nvidia/lib64:/usr/local/nvidia/lib:/usr/local/cuda/lib64/stubs:/usr/local/cuda/lib64:/usr/local/cuda/lib$LIBRARY_PATH


# python3 modules
RUN wget https://bootstrap.pypa.io/pip/2.7/get-pip.py && python3 get-pip.py && \
        pip3 install --upgrade --no-cache-dir wheel six setuptools cython numpy scipy==1.2.0 \
                matplotlib seaborn scikit-learn scikit-image pillow requests \
                jupyterlab networkx h5py pandas plotly protobuf tqdm tensorboardX colorama setproctitle && \
        pip3 install https://download.pytorch.org/whl/cu90/torch-1.0.0-cp35-cp35m-linux_x86_64.whl

RUN wget https://bootstrap.pypa.io/get-pip.py && python3.6 get-pip.py && python3.6 -m pip install flow_vis opencv-python

# Build networks.
COPY networks /flownet2-pytorch/networks
RUN cd /flownet2-pytorch/networks && ./install.sh
