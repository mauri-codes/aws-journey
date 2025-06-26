if [ -z "$CODEBUILD_BUILD_ID" ] || [ ! -f /tmp/AppInstance.zip ]; then
    BUCKET=`aws ssm get-parameter --name "/Infra/State/Bucket/Name" | jq '.Parameter | .Value' | tr -d '"'`
    aws s3 cp s3://$BUCKET/labs/NATInstances/package/AppInstance /tmp/NATInstances/AppInstance
fi
