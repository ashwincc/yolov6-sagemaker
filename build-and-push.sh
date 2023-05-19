#!/bin/bash
image="yolov6s-sagemaker-training:$(date '+%Y-%m-%d')"
if [ "$image" == "" ]
then
    echo "Usage: $0 <image-name>"
    exit 1
fi
account=$(aws sts get-caller-identity --query Account --output text)
region=$(aws configure get region)
fullname="${account}.dkr.ecr.${region}.amazonaws.com/${image}"

echo 'ImageName: '$fullname

aws ecr get-login-password --region ${region} | docker login --username AWS --password-stdin 763104351884.dkr.ecr.${region}.amazonaws.com
base_img='763104351884.dkr.ecr.'$region'.amazonaws.com/pytorch-training:2.0.0-gpu-py310-cu118-ubuntu20.04-ec2'
echo 'base_img:'$base_img

cd container

echo 'Building docker image..'

docker build -t ${image} -f Dockerfile --build-arg BASE_IMG=$base_img .
docker tag ${image} ${fullname}

aws ecr get-login-password --region ${region} | docker login --username AWS --password-stdin ${account}.dkr.ecr.${region}.amazonaws.com

aws ecr describe-repositories --repository-names "${image}" > /dev/null 2>&1

if [ $? -ne 0 ]
then
    aws ecr create-repository --repository-name "${image}" > /dev/null
fi

docker push ${fullname}

echo -e "\nSuccessfully Built ${fullname} and pushed."