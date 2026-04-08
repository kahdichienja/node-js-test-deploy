# Node.js API & Kubernetes Deployment

Welcome to the Node.js API project! This repository contains a complete Dockerized backend along with Kubernetes deployment configurations and automated pipelines.

## Project Structure

* `server.js` - The main Express application
* `Dockerfile` - For containerizing the application
* `k8s/` - Contains all Kubernetes declarative manifests (Namespace, Deployment, Service, Ingress)
* `deploy.sh` - Your one-click local deployment script
* `push.sh` - Helper script to securely push images to Docker Hub
* `.github/workflows/` - Automated GitHub Actions pipeline for CI/CD pushing

## Prerequisites

Before you start, make sure you have the following installed:
* **Docker**
* **Minikube** (Local Kubernetes cluster)
* **kubectl**
* Optional: A Docker Hub account to push your images.

## How to Run Locally

### 1. Set Up Environment Secrets
We use a `.env` file to manage Docker Hub credentials locally.
Create a `.env` file in the root of the project with your details:
```env
DOCKER_USERNAME=your_username
DOCKER_TOKEN=your_docker_personal_access_token
IMAGE_NAME=your_username/node-js-test-deploy
```

### 2. Start Minikube
Fire up your local cluster:
```bash
minikube start
```

### 3. Deploy
Run the master deployment script. It will automatically:
- Enable the necessary Minikube Ingress add-on
- Build the Docker image locally
- Push it directly to your Docker registry using `push.sh`
- Apply all Kubernetes configurations to the `node-api-ns` namespace

```bash
./deploy.sh
```

### 4. Test the API
The deployment script will wait for readiness and output your Minikube IP.
```bash
# Example curl requests
curl http://<YOUR_MINIKUBE_IP>/
curl http://<YOUR_MINIKUBE_IP>/health
```

## Continuous Integration (GitHub Actions)

A `.github/workflows/docker-push.yml` workflow is included! 
Every time you push to the `main` branch, GitHub Actions will automatically log in and push the latest build to Docker Hub.

**Important**: Navigate to your GitHub repository **Settings -> Secrets and variables -> Actions** and add the following repository secrets:
* `DOCKER_USERNAME`
* `DOCKER_TOKEN`

---
Happy Deploying!
