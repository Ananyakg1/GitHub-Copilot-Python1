# Azure DevOps Pipeline Configuration

## Required Variables
Before running the pipeline, make sure to set up the following variables in your Azure DevOps project:

### Variable Group: "azure-config"
- `ACR_NAME`: Your Azure Container Registry name
- `ACR_RESOURCE_GROUP`: Resource group containing your ACR
- `ACR_SUBSCRIPTION`: Your Azure subscription ID
- `AKS_CLUSTER_NAME`: Your AKS cluster name
- `AKS_RESOURCE_GROUP`: Resource group containing your AKS cluster

### Secret Variables
- `SNYK_TOKEN`: Your Snyk authentication token

### Service Connection
- `azure-service-connection`: Azure Resource Manager service connection with permissions to:
  - Push images to ACR
  - Deploy to AKS cluster

## Pipeline Features

### Security Scanning
- **Snyk dependency scanning**: Scans Python dependencies for known vulnerabilities
- **Snyk container scanning**: Scans Docker images for vulnerabilities
- **Severity threshold**: Set to "high" - pipeline continues on medium/low severity issues

### Docker Security Features
- Uses Python 3.11 slim base image for smaller attack surface
- Runs as non-root user
- Includes security updates during build
- Optimized layer caching
- Health checks included

### Kubernetes Security
- **ClusterIP service**: Internal-only access as requested
- **Security context**: Runs as non-root user
- **Resource limits**: CPU and memory limits defined
- **Probes**: Liveness and readiness probes configured
- **Rolling updates**: Zero-downtime deployments

### Pipeline Stages
1. **Build Stage**:
   - Python environment setup
   - Dependency installation
   - Unit tests execution
   - Security scanning (Snyk)
   - Docker image build
   - Container vulnerability scan
   - Push to ACR

2. **Deploy Stage**:
   - Install kubectl
   - Connect to AKS cluster
   - Deploy application
   - Verify deployment
   - Health checks

## Usage Instructions

1. **Set up Azure resources**:
   ```bash
   # Create resource group
   az group create --name your-resource-group --location eastus
   
   # Create ACR
   az acr create --name your-acr-name --resource-group your-resource-group --sku Basic
   
   # Create AKS cluster
   az aks create --name your-aks-cluster --resource-group your-aks-resource-group --node-count 2
   ```

2. **Configure variables in Azure DevOps**:
   - Go to Pipelines → Library → Variable groups
   - Create a new variable group called "azure-config"
   - Add all required variables listed above

3. **Set up service connection**:
   - Go to Project Settings → Service connections
   - Create Azure Resource Manager connection
   - Name it "azure-service-connection"

4. **Get Snyk token**:
   - Sign up at https://snyk.io
   - Go to Account Settings → API Token
   - Copy the token and add it as a secret variable

5. **Run the pipeline**:
   - The pipeline will trigger automatically on pushes to main/develop branches
   - Monitor the build and deployment progress in Azure DevOps

## Troubleshooting

### Common Issues
- **ACR login fails**: Check service connection permissions
- **Snyk scan fails**: Verify SNYK_TOKEN is set correctly
- **Kubernetes deployment fails**: Check AKS cluster accessibility
- **Image pull fails**: Ensure ACR is accessible from AKS

### Security Considerations
- Pipeline runs with minimum required permissions
- Container runs as non-root user
- Security scanning integrated into CI/CD
- Secrets are stored securely in Azure DevOps
- Regular security updates applied to base images
