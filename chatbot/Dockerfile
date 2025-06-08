# syntax=docker/dockerfile:1

# Build stage
FROM python:3.9-slim AS builder

# Set working directory
WORKDIR /app

# Install build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements file
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir --target=/app/deps -r requirements.txt \
    && find /app/deps -name "*.pyc" -delete \
    && find /app/deps -name "__pycache__" -delete

# Runtime stage
FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Copy only the necessary dependencies from the builder stage
COPY --from=builder /app/deps /usr/local/lib/python3.9/site-packages/

# Copy only necessary application files
COPY server.py .
COPY ai_service.py .
COPY dto/ ./dto/

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1
ENV PIP_NO_CACHE_DIR=1

# Expose the port the app runs on
EXPOSE 8005

# Default command
CMD ["python", "server.py"]