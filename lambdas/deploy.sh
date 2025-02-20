
FILE_PATH=$1

PROJECT=`echo $FILE_PATH | cut -d "/" -f 1`
LAMBDA=`echo $FILE_PATH | cut -d "/" -f 2`
BUCKET=`aws ssm get-parameter --name "/Infra/State/Bucket/Name" | jq '.Parameter | .Value' | tr -d '"'`

cd $FILE_PATH
GOARCH=amd64 GOOS=linux go build -o bootstrap main.go
zip $LAMBDA.zip bootstrap

ls
echo $LAMBDA.zip

aws s3 cp $LAMBDA.zip s3://$BUCKET/lambda/$PROJECT/$LAMBDA.zip
