set -e

NAME="kubernetes-demo-app"
USERNAME="htrix"
IMAGE="$USERNAME/$NAME:latest"

echo "Building Docker image..."
docker build -t $IMAGE .

echo "Pushing Docker image to Docker Hub..."
docker push $IMAGE

echo "Deploying to Kubernetes..."
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

echo "Deployment complete. getting pods ..."
kubectl get pods

echo "Getting services ..."
kubectl get services

echo "To access the application, use the following command to port-forward:"
echo "kubectl port-forward svc/$NAME 8080:80"

kubectl get services $NAME-service
