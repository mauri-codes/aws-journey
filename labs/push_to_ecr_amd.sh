
cd deploy_lab
./create_deploy_script.sh
cd ..

export REPO_DOMAIN=`aws ssm get-parameter --name "/Infra/Ecr/Deployer/RepoDomain" | jq '.Parameter | .Value' | tr -d '"'`
export REPO_URL=`aws ssm get-parameter --name "/Infra/Ecr/Deployer/RepoUrl" | jq '.Parameter | .Value' | tr -d '"'`

aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $REPO_DOMAIN
#https://www.docker.com/blog/how-to-rapidly-build-multi-architecture-images-with-buildx/
# FOR NON-ARM PCs
# docker buildx -t deployer .
# docker tag deployer $REPO_URL:latest
# docker tag $REPO_URL:latest
# docker push $REPO_URL:latest
# FOR ARM PCs
docker buildx build --push \
--platform linux/amd64,linux/arm64 \
--tag $REPO_URL:latest .