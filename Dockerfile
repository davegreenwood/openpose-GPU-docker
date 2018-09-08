FROM bvlc/caffe:gpu
# currently cuda 8.0 cdnn 6.0

LABEL maintainer digitalhumangroup@gmail.com

# ------------------------------------------------------------------
# openpose
# ------------------------------------------------------------------

RUN git clone  https://github.com/CMU-Perceptual-Computing-Lab/openpose.git \
    /software/openpose && \
    mkdir -p /software/openpose/build && cd /software/openpose/build && \
    cmake -D CMAKE_INSTALL_PREFIX=/usr/local  \
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
