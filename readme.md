# Openpose Dockerfile - Nvidia GPU
This docker file is built on top of the caffe gpu image. We rebuild caffe, knowing we have the correct requirements, as for some reason openpose does not find all the includes. The image includes all the available models at this time.

The image can be built with:

    sudo docker build -t openpose:gpu .

Once the image is built we connect a data directory and run the image.

    docker run --runtime=nvidia  -v /media/data1:/data -it openpose:gpu bash

The openpose binary is in the path, so we can call it:

    openpose -helpshort

The output from  `openpose -help` is saved in `help.txt`

An example for tracking a face might be:

    openpose \
    -display=0 \
    -video /data/small-test.mov \
    -face=true \
    -face_net_resolution="368x368" \
    -net_resolution="-1x640" \
    -write_json="/data/op_out/kp_368_640" \
    -write_video="/data/op_out/face_368_net_640.avi" \
    -camera_fps=59.94
