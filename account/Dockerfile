# Use official Python base image
FROM python:3.12-slim

# Avoid Python writing .pyc files and enable output flushing
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set working directory
WORKDIR /app

# Install system dependencies for pandas, numpy, pillow, openpyxl
RUN apt-get update && apt-get install -y \
    build-essential \
    libjpeg-dev \
    zlib1g-dev \
    libopenblas-dev \
    libatlas-base-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements
COPY requirements.txt .

# Install Python packages
RUN pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY . .

# Expose Django port
EXPOSE 8000

# Collect static files (optional)
# RUN python manage.py collectstatic --noinput

# Run Django server
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
