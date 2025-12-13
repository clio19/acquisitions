$ErrorActionPreference = 'Stop'

$NAME = "kubernetes-demo-app"
$USERNAME = "htrix"
$IMAGE = "$USERNAME/$NAME:latest"

Write-Host "Building Docker image..."
docker build -t $IMAGE .

Write-Host "Pushing Docker image to Docker Hub..."
docker push $IMAGE

Write-Host "Deploying to Kubernetes..."
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

Write-Host "Deployment complete. getting pods ..."
kubectl get pods

Write-Host "Getting services ..."
kubectl get services

Write-Host "To access the application, use the following command to port-forward:"
Write-Host "kubectl port-forward svc/$NAME 8080:80"

kubectl get services "${NAME}-service"