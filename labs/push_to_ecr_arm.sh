
cd deploy_lab
./create_deploy_script.sh
cd ..

export REPO_NAME=`aws ssm get-parameter --name "/Infra/Ecr/Deployer/Name" | jq '.Parameter | .Value' | tr -d '"'`
export REPO_DOMAIN=`aws ssm get-parameter --name "/Infra/Ecr/Deployer/Domain" | jq '.Parameter | .Value' | tr -d '"'`
export REPO_URL=`aws ssm get-parameter --name "/Infra/Ecr/Deployer/Url" | jq '.Parameter | .Value' | tr -d '"'`

echo $REPO_DOMAIN
echo $REPO_URL
echo $REPO_NAME

aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $REPO_DOMAIN
docker build -t $REPO_NAME .
docker tag $REPO_NAME:latest $REPO_URL:latest
docker push $REPO_URL:latest
