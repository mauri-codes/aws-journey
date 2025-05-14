# docker build -t deployer .
# docker run --rm -it -v $PWD:/tmp deployer /bin/bash
FROM redhat/ubi8:latest

WORKDIR /usr/local
RUN dnf update -y
RUN dnf install git jq -y
RUN yum install unzip -y

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install

RUN yum install -y yum-utils
RUN yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
RUN yum -y install terraform

RUN curl -L https://github.com/gruntwork-io/terragrunt/releases/download/v0.75.10/terragrunt_linux_arm64 > terragrunt
RUN chmod u+x terragrunt
RUN mv terragrunt /usr/local/bin/terragrunt

WORKDIR /
ARG CACHE_BUST=6
RUN git clone https://github.com/mauri-codes/aws-journey.git ./aws-journey --no-checkout
RUN cd ./aws-journey && git sparse-checkout init && git sparse-checkout set labs infra && git checkout main

WORKDIR /aws-journey/labs

COPY ./deploy_lab/deploy_lab_script ./deploy_lab/deploy_lab_script
