# Use a minimal Python image
FROM python:3-slim

# Expose the FastAPI app port
EXPOSE 8000

# Prevent Python from writing .pyc files and enable unbuffered output for logs
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set the working directory inside the container
WORKDIR /CI_CD/Fast_api

# Copy dependencies file first to leverage Docker caching
COPY requirements.txt .

# Install dependencies
RUN python -m pip install --no-cache-dir -r requirements.txt

# Copy the entire project directory into the container
COPY . .

# Create a non-root user and set permissions for security
RUN adduser -u 5678 --disabled-password --gecos "" appuser && chown -R appuser /CI_CD

# Switch to the non-root user
USER appuser

# Start the FastAPI application with Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "-k", "uvicorn.workers.UvicornWorker", "main:app"]

