
cd deploy_lab
./create_deploy_script.sh
cd ..

export REPO_DOMAIN=`aws ssm get-parameter --name "/Infra/Ecr/RepoDomain" | jq '.Parameter | .Value' | tr -d '"'`
export REPO_URL=`aws ssm get-parameter --name "/Infra/Ecr/RepoUrl" | jq '.Parameter | .Value' | tr -d '"'`

echo $REPO_DOMAIN
echo $REPO_URL

aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $REPO_DOMAIN
docker build -t lab-deployer .
docker tag lab-deployer:latest $REPO_URL:latest
docker push $REPO_URL:latest
