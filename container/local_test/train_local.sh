#!/bin/sh

mkdir -p test_dir/model
mkdir -p test_dir/output
mkdir -p test_dir/input/data

cd test_dir/input/data
wget https://www.dropbox.com/s/lbji5ho8b1m3op1/reduced_label_yolov6.zip?dl=1 -O dataset.zip

unzip dataset.zip 

mv reduced_label_yolov6/ dataset/

docker run -it --ipc=host --gpus=all -v $(pwd)/test_dir:/opt/ml yolov6-sagemaker-training:v1 train


rm test_dir/model/*
rm test_dir/output/*

