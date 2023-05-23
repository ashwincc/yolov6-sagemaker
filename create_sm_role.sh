#!/bin/bash

# Bash script creating sagemaker user and role.


USER_NAME='sagemaker-user'
aws iam create-user --user-name $USER_NAME
aws iam attach-user-policy --user-name $USER_NAME --policy-arn arn:aws:iam::aws:policy/AmazonSageMakerFullAccess

ROLE_NAME='sagemaker-role'
TRUST="{ \"Version\": \"2012-10-17\", \"Statement\": [ { \"Effect\": \"Allow\", \"Principal\": { \"Service\": \"sagemaker.amazonaws.com\" }, \"Action\": \"sts:AssumeRole\" } ] }"
aws iam create-role --role-name $ROLE_NAME --assume-role-policy-document "$TRUST"

# Give full/fine grain permissions of Sagemaker and S3 
aws iam attach-role-policy --role-name $ROLE_NAME --policy-arn arn:aws:iam::aws:policy/AmazonSageMakerFullAccess
aws iam attach-role-policy --role-name $ROLE_NAME --policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess

# Run this to get the role name we will be using to run the training job
aws iam get-role --role-name $ROLE_NAME --output text --query 'Role.Arn'

# Output: 
# arn:aws:iam::XXXXXXXXXXXX:role/$ROLE_NAME