
BUCKET=`aws ssm get-parameter --name "/Infra/State/Bucket/Name" | jq '.Parameter | .Value' | tr -d '"'`
echo $BUCKET
aws s3 cp s3://$BUCKET/labs/SQSVoteCollector/lambda/VoteCollector.zip modules/lambdas/VoteCollector.zip
aws s3 cp s3://$BUCKET/labs/SQSVoteCollector/lambda/VoteGenerator.zip modules/lambdas/VoteGenerator.zip
