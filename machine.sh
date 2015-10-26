#!/bin/bash

if [ "$#" -ne 3 ]; then
	echo "Usage: $0 [provider] [type] [name]"
	exit 1
fi

AWS_KEYS_PATH="/etc/aws/keys"
CMD_DMACHINE="/usr/local/bin/docker-machine"

DRIVER=$1
SIZE=$2
NAME=$3

if [ -f "$AWS_KEYS_PATH" ]; then
	source $AWS_KEYS_PATH
fi

if [ ! -f "$HOME/.machines/${DRIVER}/$SIZE" ]; then
	echo "Invalid instance size!"
	exit 1
fi

# Get defaults from common if available
if [ -f "$HOME/.machines/${DRIVER}/.common" ]; then
	source $HOME/.machines/${DRIVER}/.common
fi

# Individual definitions can add or overwrite settings
source $HOME/.machines/${DRIVER}/${SIZE}

if [ -n "$ENGINE_OPTS" ]; then
	ENGINE_OPT_STR="--engine-opt=$ENGINE_OPTS"
fi

create_amazonec2() {
	if [ $AWS_USE_SPOT ]; then
		SPOT_CMD="--amazonec2-request-spot-instance --amazonec2-spot-price=$AWS_SPOT_PRICE"
	fi

	$CMD_DMACHINE create -d amazonec2 \
       		--amazonec2-access-key=$AWS_ACCESS_KEY \
		--amazonec2-secret-key=$AWS_SECRET_KEY \
		--amazonec2-ami=$AWS_AMI \
		--amazonec2-region=$AWS_REGION \
		--amazonec2-zone=$AWS_ZONE \
		--amazonec2-vpc-id=$AWS_VPC_ID \
		--amazonec2-security-group=$AWS_SECURITY_GROUP \
		--amazonec2-instance-type=$AWS_INSTANCE_TYPE \
		--amazonec2-root-size=$AWS_ROOT_SIZE \
		$SPOT_CMD $ENGINE_OPT_STR $NAME
}

create_azure() {
	$CMD_DMACHINE create -d azure \
		--azure-subscription-id=$AZURE_SUBSCRIPTION_ID \
		--azure-subscription-cert=$AZURE_SUBSCRIPTION_CERT \
		--azure-size=$AZURE_SIZE \
		$ENGINE_OPT_STR $NAME
}

fn="create_${DRIVER}"
[ -n "$(type -t $fn)" ] && [ "$(type -t $fn)" = function ] && $fn
