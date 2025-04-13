# Author  : Prof. MM Ghassemi <ghassem3@msu.edu>
# Access instance using `docker exec -it hw3-container_flask-app bash`

# Instantiate Ubuntu 20.04
FROM ubuntu:20.04
LABEL maintainer "Mohammad Ghassemi <ghassem3@msu.edu>"
LABEL description="This is custom Docker Image for Dr. Ghassemi's Web Application Course"

# Update Ubuntu Software repository
RUN apt update
RUN apt-get update -qq

# Install MySQL and create the database
ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get install -y mysql-server 
RUN service mysql start && mysql -e "CREATE USER 'master'@'%' IDENTIFIED BY 'master';CREATE DATABASE db; GRANT ALL PRIVILEGES ON db.* TO 'master'@'%';"

# Add the Flask application and install requirements
RUN apt -y install python3-pip
RUN apt -y install vim
RUN mkdir /app
COPY . /app
WORKDIR /app
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# Open ports, set environment variables, start gunicorn.
EXPOSE 8080 
ENV PORT 8080
ENV FLASK_ENV=production
ENV PYTHONUNBUFFERED=1
ENV MYSQL_HOST=localhost
ENV MYSQL_USER=master
ENV MYSQL_PASSWORD=master
ENV MYSQL_DATABASE=db

# Start MySQL and run the application
CMD service mysql start && \
    mysql -e "ALTER USER 'master'@'%' IDENTIFIED WITH mysql_native_password BY 'master';" && \
    exec gunicorn --bind :$PORT \
    --workers 1 \
    --worker-class eventlet \
    --threads 8 \
    --timeout 0 \
    --log-level debug \
    --access-logfile - \
    --error-logfile - \
    app:app
# ----------------------------------------------------- 