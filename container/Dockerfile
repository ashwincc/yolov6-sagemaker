# This Docker file builds the Sagemaker Bring your own container for YOLOV6 Model.

ARG BASE_IMG=763104351884.dkr.ecr.us-east-1.amazonaws.com/pytorch-training:2.0.0-gpu-py310-cu118-ubuntu20.04-ec2
ARG BASE_IMG=${BASE_IMG} 

FROM ${BASE_IMG} 

ENV PATH="/opt/code:${PATH}"
WORKDIR /opt/code

RUN apt-get update && apt-get upgrade -y --no-install-recommends  
RUN apt-get install jq -y

RUN ldconfig -v

RUN cd /opt && git clone https://github.com/meituan/YOLOv6.git

ENV PATH="/opt/YOLOv6:${PATH}"

RUN pip3 install -r /opt/YOLOv6/requirements.txt  --no-cache-dir

WORKDIR /opt/YOLOv6

COPY train /opt/YOLOv6

RUN chmod -R 775 /opt/YOLOv6/train

