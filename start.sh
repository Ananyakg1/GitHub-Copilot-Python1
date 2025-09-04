#!/bin/bash
set -e

echo "Starting Flask Change Calculator Application..."
echo "Python version: $(python --version)"
echo "Current directory: $(pwd)"
echo "Files in directory: $(ls -la)"
echo "Environment variables:"
echo "  HOST: $HOST"
echo "  PORT: $PORT" 
echo "  DEBUG: $DEBUG"
echo "  PYTHONUNBUFFERED: $PYTHONUNBUFFERED"

echo "Testing Flask application import..."
python -c "import app; print('Flask app imported successfully')" || {
    echo "Failed to import Flask application"
    exit 1
}

echo "Starting Gunicorn server..."
exec gunicorn --bind "0.0.0.0:8080" --workers 1 --timeout 120 --log-level info --access-logfile - --error-logfile - app:app
