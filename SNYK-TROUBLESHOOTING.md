# 🐛 Snyk Authentication Troubleshooting Guide

## Error: SNYK-0005 Authentication Failed

If you're getting a `SNYK-0005` authentication error, follow these steps:

### 1. 🔑 Verify Your Snyk Token

#### Get Your Snyk Token:
1. Go to [snyk.io](https://snyk.io)
2. Sign up or log in
3. Navigate to **Account Settings** → **API Token**
4. Copy your token (it should look like: `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`)

### 2. 🔐 Configure GitHub Secrets

#### Add the Secret:
1. Go to your GitHub repository: https://github.com/Ananyakg1/Azure-DevOps-new
2. Navigate to **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Name: `SNYK_TOKEN`
5. Value: Paste your Snyk token (without quotes)
6. Click **Add secret**

### 3. ✅ Verify Secret Configuration

#### Check Secret is Set:
- The secret should appear in your repository secrets list
- The name must be exactly `SNYK_TOKEN` (case-sensitive)
- The value should not have any extra spaces or characters

### 4. 🔄 Test the Authentication

#### Updated Workflow Features:
The workflow now includes:
- **Token validation**: Checks if the token is properly set
- **Better error messages**: Shows clear error messages for debugging
- **Environment variables**: Passes token securely as environment variable
- **Graceful failures**: Continues pipeline even if Snyk scans fail

### 5. 🚀 Alternative: Skip Snyk Temporarily

If you want to test the pipeline without Snyk:

#### Option A: Comment out Snyk steps
```yaml
# - name: Authenticate with Snyk
#   run: |
#     # ... snyk auth steps

# - name: Snyk dependency vulnerability scan
#   run: |
#     # ... snyk test steps
```

#### Option B: Use `continue-on-error: true`
The workflow already has this configured, so Snyk failures won't break the pipeline.

### 6. 🔍 Debug Steps

#### Check Workflow Logs:
1. Go to **Actions** tab in your repository
2. Click on the failed workflow run
3. Look for the "Authenticate with Snyk" step
4. Check the error message

#### Common Issues:
- **Token not set**: The secret `SNYK_TOKEN` is not configured
- **Invalid token**: The token is expired or incorrect
- **Rate limiting**: Too many requests to Snyk API
- **Network issues**: Connectivity problems

### 7. 📋 Manual Verification

#### Test Token Locally:
```bash
# Install Snyk CLI
npm install -g snyk

# Test authentication
snyk auth YOUR_TOKEN_HERE

# Test a scan
snyk test --file=requirements.txt
```

### 8. 🎯 Workflow Status

The current workflow will:
1. **Continue on Snyk errors** - Pipeline won't fail completely
2. **Log detailed messages** - Better debugging information
3. **Skip Snyk if token missing** - Graceful degradation
4. **Complete other steps** - Docker build, push, and deploy still work

### 9. 🔐 Security Best Practices

#### Token Management:
- Never commit tokens to code
- Use GitHub secrets for sensitive data
- Rotate tokens periodically
- Monitor token usage in Snyk dashboard

#### Alternative Security Tools:
If Snyk continues to cause issues, consider:
- **Trivy**: Container vulnerability scanner
- **Safety**: Python dependency security scanner
- **Bandit**: Python code security analyzer

### 10. 🆘 Getting Help

#### If Issues Persist:
1. Check Snyk documentation: https://docs.snyk.io
2. Verify your Snyk account is active
3. Check Snyk service status: https://status.snyk.io
4. Contact Snyk support if needed

#### Quick Fix for Testing:
To test the pipeline without Snyk immediately:
```yaml
# Add this condition to skip Snyk steps
if: false
```

## 📝 Summary

The authentication error is most likely due to:
1. **Missing `SNYK_TOKEN` secret** in GitHub repository settings
2. **Invalid or expired token** from Snyk
3. **Incorrect token format** (should be UUID format)

The updated workflow provides better error handling and won't break your entire pipeline if Snyk fails.
