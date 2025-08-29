# Secure Dockerfile for Flask Application
# Use a specific, minimal, and secure Python base image
FROM python:3.11.8-slim-bullseye

# Set environment variables for security
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    FLASK_ENV=production

# Create a non-root user and group
RUN groupadd -r appuser && useradd -r -g appuser appuser

# Set work directory
WORKDIR /app

# Install system dependencies securely
RUN apt-get update \
    && apt-get install --no-install-recommends -y gcc libpq-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements and install Python dependencies
COPY requirements.txt .
RUN pip install --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY app.py .

# Change ownership to non-root user
RUN chown -R appuser:appuser /app

# Switch to non-root user
USER appuser

# Expose the application port
EXPOSE 8080

# Healthcheck for the Flask app
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD curl --fail http://localhost:8080/health || exit 1

# Run the application with Gunicorn for production
CMD ["gunicorn", "-b", "0.0.0.0:8080", "app:app", "--workers=2", "--threads=4", "--access-logfile=-", "--error-logfile=-"]
