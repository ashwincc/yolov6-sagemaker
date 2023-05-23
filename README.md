# yolov6-sagemaker
This repo provides guide for training YOLOV6 with SageMaker.  
There are two methods:  

*   Using prebuilt container provided by AWS  
*   Using custom training container  
---
## Using prebuilt container provided by AWS
For this method go through the aws_sm_yolov6.ipynb notebook.

---
## Using custom training container
Prerequisites  
  
1) Docker  
2) Aws cli 

Steps to build and push custom container.  

*   Install aws cli tool

```bash
# for debian based distros 
sudo apt install awscli
``` 
*   Create the api access key from your AWS security credential dashboard

*   Configure the aws account with the API access id created


```bash
aws configure
# paste the Key ID in the prompt
# paste the Access Key
# choose your region
# chosose json as output format
```
<img src="imgs/aws_configure.png" alt="drawing" width="300"/>

*   Login to access the DeepLearning Container image repository before pulling the image. Here are the list of <a href="https://github.com/aws/deep-learning-containers/blob/master/available_images.md">images</a>.
```bash
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 763104351884.dkr.ecr.us-east-1.amazonaws.com
#change the region as required
```
*   Pull the Base Pytorch image
```bash
docker pull 763104351884.dkr.ecr.us-east-1.amazonaws.com/pytorch-training:2.0.0-gpu-py310-cu118-ubuntu20.04-ec2
```

*   Clone the repo
```bash
git clone https://github.com/ashwincc/yolov6-sagemaker.git
cd yolov6-sagemaker/container
```

*   Login into your ecr 
```bash
aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <account>.dkr.ecr.<region>.amazonaws.com
```


*   Build the docker  image and tag.

```bash
REPO='yolov6s-sagemaker-training'
YOLO_IMAGE=$REPO:$(date '+%Y-%m-%d')

docker build . -t $YOLO_IMAGE
docker tag $YOLO_IMAGE <account>.dkr.ecr.<region>.amazonaws.com/$YOLO_IMAGE
```

*   Create the repository and push.
```bash
aws ecr create-repository --repository-name $REPO

docker push <account>.dkr.ecr.<region>.amazonaws.com/$YOLO_IMAGE
```
---------------

Todo:

* [ ] Add Tensorboard for training visualisation.


### References:
- https://docs.aws.amazon.com/sagemaker/latest/dg/adapt-training-container.html
- https://docs.aws.amazon.com/sagemaker/latest/dg/docker-containers-create.html
- https://github.com/HKT-SSA/yolov5-on-sagemaker/
