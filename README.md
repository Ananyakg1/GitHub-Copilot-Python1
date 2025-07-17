# Python Flask Application with Azure DevOps CI/CD

This repository contains a Python Flask application with a complete CI/CD pipeline for Azure DevOps, including Docker containerization and Kubernetes deployment.

## 📁 Project Structure

```
├── app.py                  # Main Flask application
├── test_app.py            # Unit tests
├── requirements.txt       # Python dependencies
├── requirements-test.txt  # Test dependencies
├── Dockerfile            # Docker image configuration
├── .dockerignore         # Docker build exclusions
├── azure-pipelines.yml   # Azure DevOps pipeline
├── k8s-deployment.yaml   # Kubernetes deployment configuration
├── PIPELINE-CONFIG.md    # Pipeline setup instructions
└── README.md            # This file
```

## 🚀 Features

### Application Features
- **Flask REST API** with health endpoint
- **Change calculator** - Calculate coin change for given amounts
- **Production-ready** with Gunicorn WSGI server
- **Health checks** built-in

### Security Features
- **Vulnerability-free Docker image** using Python 3.11 slim
- **Non-root user** execution
- **Snyk security scanning** for dependencies and containers
- **Security context** in Kubernetes deployment
- **Resource limits** and security policies

### DevOps Features
- **Complete CI/CD pipeline** with Azure DevOps
- **Docker containerization** with multi-stage builds
- **Kubernetes deployment** with ClusterIP service
- **Automated testing** with pytest
- **Security scanning** integrated into pipeline
- **Rolling updates** with zero downtime

## 🔧 Local Development

### Prerequisites
- Python 3.11+
- Docker (for containerization)
- kubectl (for Kubernetes deployment)

### Setup
1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd Azure-DevOps-new
   ```

2. **Install dependencies**
   ```bash
   pip install -r requirements.txt
   pip install -r requirements-test.txt
   ```

3. **Run tests**
   ```bash
   python -m pytest test_app.py -v
   ```

4. **Run the application**
   ```bash
   python app.py
   ```
   
   The application will be available at `http://localhost:8080`

### API Endpoints
- `GET /` - Health check endpoint
- `GET /change/<dollar>/<cents>` - Calculate coin change
  - Example: `GET /change/1/34` returns change for $1.34

## 🐳 Docker Usage

### Build the image
```bash
docker build -t python-flask-app .
```

### Run the container
```bash
docker run -p 8080:8080 python-flask-app
```

### Security scanning (requires Snyk)
```bash
snyk container test python-flask-app
```

## ☸️ Kubernetes Deployment

The application is configured to run in Kubernetes with:
- **ClusterIP service** (internal access only)
- **3 replicas** for high availability
- **Resource limits** for stability
- **Health checks** for reliability
- **Rolling updates** for zero downtime

### Deploy to cluster
```bash
kubectl apply -f k8s-deployment.yaml
```

### Access the application
Since the service is ClusterIP, access it via:
1. **Port forwarding**: `kubectl port-forward svc/python-flask-app-service 8080:80 -n github-copilot-ns`
2. **Ingress controller** (configured in k8s-deployment.yaml)
3. **Internal cluster access** from other pods in the same namespace

## 🔒 Security Considerations

### Docker Security
- ✅ Uses official Python slim image
- ✅ Runs as non-root user
- ✅ Includes security updates
- ✅ Minimal attack surface
- ✅ No sensitive data in image
- ✅ Health checks included

### Kubernetes Security
- ✅ Security context configured
- ✅ Resource limits enforced
- ✅ Non-root user execution
- ✅ Read-only root filesystem option
- ✅ Capabilities dropped
- ✅ ClusterIP service (internal only)

### Pipeline Security
- ✅ Dependency vulnerability scanning
- ✅ Container image scanning
- ✅ Security monitoring
- ✅ Secrets management
- ✅ Minimum required permissions

## 🚀 CI/CD Pipeline

This project supports both Azure DevOps and GitHub Actions pipelines:

### GitHub Actions Pipeline
The GitHub Actions pipeline (`.github/workflows/ci-cd.yml`) includes:

#### Build Stage
1. **Environment setup** - Python 3.11, dependency caching
2. **Testing** - Unit tests with pytest
3. **Security scanning** - Snyk dependency and container scans
4. **Docker build** - Multi-stage, optimized build
5. **Registry push** - Push to Azure Container Registry

#### Deploy Stage
1. **Tool installation** - kubectl setup
2. **Cluster connection** - AKS authentication
3. **Application deployment** - Kubernetes deployment
4. **Health verification** - Deployment status checks

### Azure DevOps Pipeline
The Azure DevOps pipeline (`azure-pipelines.yml`) provides the same functionality with Azure-specific integrations.

### Pipeline Setup
- **GitHub Actions**: Refer to `GITHUB-ACTIONS-SETUP.md` for detailed setup instructions
- **Azure DevOps**: Refer to `PIPELINE-CONFIG.md` for detailed setup instructions

## 📊 Monitoring and Observability

### Health Checks
- **Liveness probe**: Checks if app is running
- **Readiness probe**: Checks if app is ready for traffic
- **Startup probe**: Initial health check

### Resource Monitoring
- **CPU limits**: 200m limit, 100m request
- **Memory limits**: 256Mi limit, 128Mi request
- **Replica monitoring**: 3 replicas with rolling updates

## 🛠️ Troubleshooting

### Common Issues

1. **Build failures**
   - Check Python version compatibility
   - Verify all dependencies are in requirements.txt
   - Ensure Docker daemon is running

2. **Security scan failures**
   - Update dependencies to latest secure versions
   - Check Snyk token configuration
   - Review vulnerability severity settings

3. **Deployment issues**
   - Verify AKS cluster access
   - Check service connection permissions
   - Ensure image is pushed to ACR

4. **Application not accessible**
   - Remember service is ClusterIP (internal only)
   - Use port forwarding for external access
   - Check ingress configuration

### Debug Commands
```bash
# Check pod status
kubectl get pods -l app=python-flask-app -n github-copilot-ns

# View logs
kubectl logs -l app=python-flask-app -n github-copilot-ns

# Describe deployment
kubectl describe deployment python-flask-app -n github-copilot-ns

# Check service
kubectl get svc python-flask-app-service -n github-copilot-ns
```

## 📋 Requirements

### Azure Resources
- Azure Container Registry
- Azure Kubernetes Service
- Azure DevOps project
- Service principal with appropriate permissions

### Tools
- Docker
- kubectl
- Snyk account (for security scanning)
- Azure CLI

## 📝 License

This project is provided as-is for demonstration purposes.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests and security scans
5. Submit a pull request

---

For detailed pipeline configuration and setup instructions, see `PIPELINE-CONFIG.md`.
