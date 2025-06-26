if [ -z "$CODEBUILD_BUILD_ID" ] || [ ! -f /tmp/VoteCollector.zip ]; then
    BUCKET=`aws ssm get-parameter --name "/Infra/State/Bucket/Name" | jq '.Parameter | .Value' | tr -d '"'`
    aws s3 cp s3://$BUCKET/labs/SQSVoteCollector/lambda/VoteCollector.zip /tmp/VoteCollector.zip
    aws s3 cp s3://$BUCKET/labs/SQSVoteCollector/lambda/VoteGenerator.zip /tmp/VoteGenerator.zip
fi
