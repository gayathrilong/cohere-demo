#/bin/bash

export REGION="${REGION:-us-east-1}"

cd terraform_bootstrap
terraform init
export ECR_REPO=$(terraform apply -var region=${REGION} -auto-approve | grep "ecr_url" | awk '{print $3}' | tr -d '"' | tr -d '=' | tr -d '\n' | tr -d ' ')
export ECR_URL=$(echo ${ECR_REPO} | cut -d / -f 1)
aws ecr get-login-password --region ${REGION} | docker login --username AWS --password-stdin ${ECR_URL}
cd ..
#Since we're building on an M1 mac, we need to build an amd64 container for ECS
docker buildx build --platform linux/amd64 --push -t ${ECR_REPO}:latest .
cd terraform_ecs
terraform init
terraform apply -var region=${REGION} -auto-approve