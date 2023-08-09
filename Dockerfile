# Use the official Python base image
FROM python:3.9

# Set the working Directory
WORKDIR /app

# Copy the requirements.txt file to the container
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application code to the container
COPY app.py .

# Expose the port on which the Flask application will run (change if needed)
EXPOSE 5000 

# Start the application
CMD ["python", "app.py"]