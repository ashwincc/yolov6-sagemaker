#!/bin/sh
# creating the folder structure
mkdir -p test_dir/model
mkdir -p test_dir/output
mkdir -p local_test/test_dir/input/data/cfg
mkdir -p local_test/test_dir/input/data/weights

#<----------------------------------------------->
cd test_dir/input/
wget https://www.dropbox.com/s/lbji5ho8b1m3op1/reduced_label_yolov6.zip?dl=1 -O dataset.zip

unzip dataset.zip reduced_label_yolov6/images/* -d .
unzip dataset.zip reduced_label_yolov6/labels/* -d .
mv reduced_label_yolov6/* data/
#<----------------------------------------------->

!wget https://github.com/meituan/YOLOv6/releases/download/0.3.0/yolov6s.pt
!mv yolov6s.pt container/local_test/test_dir/input/data/weights/
#<----------------------------------------------->



!wget https://raw.githubusercontent.com/meituan/YOLOv6/main/configs/yolov6s_finetune.py
!mv yolov6s_finetune.py container/local_test/test_dir/input/data/cfg/yolov6s_finetune.py
docker run -it --ipc=host --gpus=all -v $(pwd)/test_dir:/opt/ml yolov6-sagemaker-training:v1 train


rm test_dir/model/*
rm test_dir/output/*

