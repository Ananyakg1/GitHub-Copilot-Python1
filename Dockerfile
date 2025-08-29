# Use specific Python version based on slim image for security
FROM python:3.11.7-slim-bookworm

# Set metadata
LABEL maintainer="github-copilot-app" \
      version="1.0.0" \
      description="Secure Flask application for change calculation"

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PORT=8080 \
    HOST=0.0.0.0

# Create non-root user
RUN groupadd -r appgroup && \
    useradd -r -g appgroup -d /app -s /bin/bash appuser && \
    mkdir -p /app && \
    chown -R appuser:appgroup /app

# Install security updates and required packages
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        curl \
        ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set working directory
WORKDIR /app

# Copy requirements first for better caching
COPY --chown=appuser:appgroup requirements.txt .

# Install Python dependencies with security considerations
RUN pip install --no-cache-dir --upgrade pip==23.3.2 && \
    pip install --no-cache-dir --no-deps -r requirements.txt && \
    pip check

# Copy application code
COPY --chown=appuser:appgroup app.py .

# Switch to non-root user
USER appuser

# Expose port
EXPOSE 8080

# Add health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8080/health || exit 1

# Use gunicorn for production with security settings
CMD ["gunicorn", "--bind", "0.0.0.0:8080", "--workers", "4", "--threads", "2", "--timeout", "60", "--keep-alive", "2", "--max-requests", "1000", "--max-requests-jitter", "100", "--preload", "app:app"]
