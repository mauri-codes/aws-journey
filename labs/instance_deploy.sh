# ./instance_deploy.sh NATInstances/instance/AppInstance
FILE_PATH=$1
LAB=`echo $FILE_PATH | cut -d "/" -f 1`
INSTANCE=`echo $FILE_PATH | cut -d "/" -f 3`
BUCKET=`aws ssm get-parameter --name "/Infra/State/Bucket/Name" | jq '.Parameter | .Value' | tr -d '"'`

cd $FILE_PATH
GOARCH=amd64 GOOS=linux go build -o bootstrap main.go
# zip $INSTANCE.zip bootstrap

echo s3://$BUCKET/labs/$LAB/package/$INSTANCE

aws s3 cp bootstrap s3://$BUCKET/labs/$LAB/package/$INSTANCE
