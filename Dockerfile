FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu16.04
LABEL maintainer digitalhumangroup@gmail.com

RUN echo "Installing dependencies..." && \
	apt-get -y --no-install-recommends update && \
	apt-get -y --no-install-recommends upgrade && \
	apt-get install -y --no-install-recommends \
	build-essential \
	cmake \
	git \
	libatlas-base-dev \
	libprotobuf-dev \
	libleveldb-dev \
	libsnappy-dev \
	libhdf5-serial-dev \
	protobuf-compiler \
	libboost-all-dev \
	libgflags-dev \
	libgoogle-glog-dev \
	liblmdb-dev \
	pciutils \
	python3-setuptools \
	python3-dev \
	python3-pip \
	opencl-headers \
	ocl-icd-opencl-dev \
	libviennacl-dev \
	libcanberra-gtk-module \
	libopencv-dev && \
	python3 -m pip install \
	numpy \
	protobuf \
	opencv-python


# ------------------------------------------------------------------
# openpose
# ------------------------------------------------------------------

RUN git clone  https://github.com/CMU-Perceptual-Computing-Lab/openpose.git \
    /software/openpose && \
    mkdir -p /software/openpose/build && cd /software/openpose/build && \
    cmake -D CMAKE_INSTALL_PREFIX=/usr/local  \
	-D BUILD_PYTHON=ON \
    -D BUILD_CAFFE=ON \
    -D BUILD_EXAMPLES=ON \
    -D GPU_MODE=CUDA \
    -D CMAKE_BUILD_TYPE=Release \
    -D DOWNLOAD_BODY_COCO_MODEL=ON \
    -D DOWNLOAD_BODY_MPI_MODEL=ON \
    -D DOWNLOAD_HAND_MODEL=ON \
    -D DOWNLOAD_FACE_MODEL=ON .. && \
    make -j"$(nproc)" && \
    make install
    

# for convenience, link the openpose binary to path directory
RUN ln -s /software/openpose/build/examples/openpose/openpose.bin \
    /usr/local/bin/openpose

# the model directory has to be available, default is the working directory
RUN ln -s /software/openpose/models /workspace/models

# link the rest of the examples to the working directory
RUN ln -s /software/openpose/build/examples /workspace/examples
