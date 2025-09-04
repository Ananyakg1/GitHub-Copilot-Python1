# Use specific Python version with alpine for security
FROM python:3.11.9-alpine3.19

# Set metadata
LABEL maintainer="ananya.kg@example.com"
LABEL description="Flask Change Calculator Application"
LABEL version="1.0.0"

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONPATH=/app \
    PORT=8080 \
    HOST=0.0.0.0 \
    DEBUG=False

# Install system dependencies and security updates
RUN apk update && \
    apk upgrade && \
    apk add --no-cache \
        ca-certificates \
        tzdata && \
    apk add --no-cache --virtual .build-deps \
        gcc \
        musl-dev && \
    rm -rf /var/cache/apk/*

# Create non-root user
RUN addgroup -g 1001 -S appgroup && \
    adduser -u 1001 -S appuser -G appgroup

# Create app directory
WORKDIR /app

# Copy requirements first for better caching
COPY requirements.txt .

# Install Python dependencies with security considerations
RUN pip install --no-cache-dir --upgrade pip==24.0 && \
    pip install --no-cache-dir -r requirements.txt && \
    pip install --no-cache-dir --upgrade \
        setuptools==69.0.0 \
        wheel==0.42.0

# Remove build dependencies
RUN apk del .build-deps

# Copy application code
COPY app.py .

# Change ownership to non-root user
RUN chown -R appuser:appgroup /app

# Switch to non-root user
USER appuser

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8080/health')" || exit 1

# Run the application
CMD ["gunicorn", "--bind", "0.0.0.0:8080", "--workers", "4", "--timeout", "120", "--keepalive", "2", "--max-requests", "1000", "--preload", "app:app"]
