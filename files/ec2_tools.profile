#!/bin/bash
# Managed by puppet - do not modify

export EC2_HOME=/opt/ec2-api-tools
export AWS_IAM_HOME=/opt/iam-api-tools

if [ ! -d ~/.aws ]; then
	mkdir ~/.aws
fi

if [[ ! -f ~/.aws/pk.pem || ! -f ~/.aws/cert.pem ]]; then
	echo "To configure the EC2 tools:"
	echo "add your private key to ~/.aws/pk.pem"
	echo "and your cert file to ~/.aws/cert.pem"
else
	export EC2_PRIVATE_KEY=~/.aws/pk.pem
	export EC2_CERT=~/.aws/cert.pem
	export PATH=$PATH:$EC2_HOME/bin:$AWS_IAM_HOME/bin
  export AWS_CREDENTIAL_FILE=~/.aws/iam-credentials
fi


