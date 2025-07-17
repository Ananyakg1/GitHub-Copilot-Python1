# GitHub Actions Setup Guide

## Required Secrets Configuration

To run this pipeline, you need to configure the following secrets in your GitHub repository:

### 🔐 Setting up GitHub Secrets

1. Go to your GitHub repository
2. Navigate to **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret** and add each of the following:

### Authentication Secrets
- **`SNYK_TOKEN`**: Your Snyk authentication token
  - Get from: https://snyk.io → Account Settings → API Token
  
- **`AZURE_CLIENT_ID`**: Azure Service Principal Client ID
- **`AZURE_CLIENT_SECRET`**: Azure Service Principal Client Secret  
- **`AZURE_SUSCRIPTION_ID`**: Your Azure Subscription ID
- **`AZURE_TENANT_ID`**: Your Azure Tenant ID

### Registry Secrets
- **`REGISTRY_LOGIN_SERVER`**: Your ACR login server (e.g., `myregistry.azurecr.io`)
- **`REGISTRY_USERNAME`**: ACR username
- **`REGISTRY_PASSWORD`**: ACR password

### AKS Secrets
- **`AKS_CLUSTER_NAME`**: Your AKS cluster name
- **`AKS_RESOURCE_GROUP`**: Resource group containing your AKS cluster

## 🔧 Azure Service Principal Setup

Create a service principal with the required permissions:

```bash
# Create service principal
az ad sp create-for-rbac --name "github-actions-sp" --role contributor --scopes /subscriptions/{subscription-id}

# The output will contain:
# {
#   "appId": "<AZURE_CLIENT_ID>",
#   "displayName": "github-actions-sp",
#   "name": "github-actions-sp",
#   "password": "<AZURE_CLIENT_SECRET>",
#   "tenant": "<AZURE_TENANT_ID>"
# }
```

## 📋 Azure Container Registry Setup

Get your ACR credentials:

```bash
# Get ACR login server
az acr show --name <your-acr-name> --query loginServer --output tsv

# Get ACR username and password
az acr credential show --name <your-acr-name>
```

## 🚀 Workflow Features

### Build Job (`build-and-test`)
- **Triggers**: Push to main/develop, PRs to main
- **Python setup**: 3.11 with dependency caching
- **Testing**: Runs pytest test suite
- **Security scanning**: Snyk dependency and container scans
- **Docker build**: Multi-stage build with security best practices
- **Registry push**: Pushes to Azure Container Registry

### Deploy Job (`deploy`)
- **Triggers**: Only on main branch pushes
- **Environment**: Uses GitHub environment protection
- **Kubernetes**: Deploys to AKS cluster in `github-copilot-ns` namespace
- **Verification**: Health checks and rollout status
- **Access info**: Provides port forwarding instructions

## 🔒 Security Features

### GitHub Actions Security
- **Secret management**: All sensitive data stored as GitHub secrets
- **Environment protection**: Production deployments require approval
- **Principle of least privilege**: Service principal has minimal required permissions
- **Branch protection**: Deploys only from main branch

### Container Security
- **Vulnerability scanning**: Snyk scans dependencies and container images
- **Non-root execution**: Container runs as non-privileged user
- **Security updates**: Base image includes latest security patches
- **Minimal attack surface**: Slim base image with only required components

### Kubernetes Security
- **Namespace isolation**: Deploys to dedicated namespace
- **Resource limits**: CPU and memory constraints
- **Security context**: Non-root user, dropped capabilities
- **ClusterIP service**: Internal-only access

## 📊 Monitoring and Observability

### Workflow Monitoring
- **Build status**: GitHub Actions provides detailed build logs
- **Security reports**: Snyk integration for vulnerability tracking
- **Deployment status**: Kubernetes rollout verification
- **Health checks**: Application readiness verification

### Application Monitoring
- **Health endpoints**: `/health` endpoint for monitoring
- **Kubernetes probes**: Liveness and readiness checks
- **Logging**: Structured logging with timestamps
- **Resource usage**: Memory and CPU monitoring

## 🔄 Workflow Triggers

### Automatic Triggers
- **Push to main**: Full build and deploy
- **Push to develop**: Build and test only
- **Pull requests**: Build and test for validation

### Manual Triggers
- **Workflow dispatch**: Manual execution from GitHub UI
- **Re-run failed jobs**: Restart specific jobs

## 🐛 Troubleshooting

### Common Issues

#### Authentication Errors
```bash
# Verify service principal permissions
az role assignment list --assignee <AZURE_CLIENT_ID>

# Test ACR access
az acr login --name <your-acr-name>
```

#### Build Failures
- Check Python dependencies in `requirements.txt`
- Verify Docker build context
- Review security scan results

#### Deployment Issues
- Verify AKS cluster accessibility
- Check namespace permissions
- Review Kubernetes events: `kubectl get events -n github-copilot-ns`

### Debug Commands
```bash
# Check workflow runs
gh run list

# View workflow logs
gh run view <run-id>

# Check pod status
kubectl get pods -n github-copilot-ns -l app=python-flask-app

# View application logs
kubectl logs -n github-copilot-ns -l app=python-flask-app
```

## 📁 File Structure

```
.github/
└── workflows/
    └── ci-cd.yml          # GitHub Actions workflow
k8s-deployment.yaml        # Kubernetes manifests
Dockerfile                 # Container image definition
requirements.txt           # Python dependencies
requirements-test.txt      # Test dependencies
app.py                     # Flask application
test_app.py               # Test suite
```

## 🌐 Environment Setup

### Development Environment
```bash
# Create development environment
python -m venv venv
source venv/bin/activate  # Linux/Mac
# or
venv\Scripts\activate     # Windows

# Install dependencies
pip install -r requirements.txt
pip install -r requirements-test.txt
```

### Production Environment
- **Container**: Docker with Gunicorn WSGI server
- **Orchestration**: Kubernetes with 3 replicas
- **Networking**: ClusterIP service with Ingress option
- **Storage**: Ephemeral storage (stateless application)

## 🔧 Configuration Management

### Environment Variables
- **`DEBUG`**: Enable/disable debug mode
- **`PORT`**: Application port (default: 8080)
- **`HOST`**: Bind address (default: 0.0.0.0)

### Kubernetes Configuration
- **Namespace**: `github-copilot-ns`
- **Service Type**: ClusterIP
- **Replicas**: 3
- **Resource Limits**: 200m CPU, 256Mi memory

## 📈 Performance Considerations

### Container Optimization
- **Multi-stage builds**: Minimal production image
- **Layer caching**: Efficient Docker builds
- **Dependency caching**: Faster CI/CD runs
- **Resource limits**: Prevent resource exhaustion

### Kubernetes Optimization
- **Horizontal scaling**: Ready for HPA
- **Rolling updates**: Zero-downtime deployments
- **Health checks**: Fast failure detection
- **Resource requests**: Proper scheduling

---

For questions or issues, refer to the troubleshooting section or create an issue in the repository.
