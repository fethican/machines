#!/bin/bash

AWS_KEYS_PATH="/etc/aws/keys"

if [ ! "$#" -eq 2 ]; then
	echo "Usage: $0 [type] [name]"
	exit 1
fi

SIZE=$1
NAME=$2

if [ -f "$AWS_KEYS_PATH" ]; then
	source $AWS_KEYS_PATH
fi

if [ ! -f "$HOME/.machines/$SIZE" ]; then
	echo "Invalid intance size!"
	exit 1
fi

# Get defaults from common if available
if [ -f "$HOME/.machines/common_" ]; then
	source $HOME/.machines/common_
fi

# Individual definitions can add or overwrite settings
source $HOME/.machines/${SIZE}

/usr/local/bin/docker-machine create -d amazonec2 \
       	--amazonec2-access-key=$AWS_ACCESS_KEY \
	--amazonec2-secret-key=$AWS_SECRET_KEY \
	--amazonec2-ami=$AWS_AMI \
	--amazonec2-region=$AWS_ZONE \
	--amazonec2-vpc-id=$AWS_VPC_ID \
	--amazonec2-security-group=$AWS_SECURITY_GROUP \
	--amazonec2-instance-type=$AWS_INSTANCE_TYPE \
	--amazonec2-root-size=$AWS_ROOT_SIZE \
	$NAME
