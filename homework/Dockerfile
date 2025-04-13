# Author  : Prof. MM Ghassemi <ghassem3@msu.edu>


# Instantiate Ubuntu 20.04
FROM ubuntu:20.04
LABEL maintainer "Mohammad Ghassemi <ghassem3@msu.edu>"
LABEL description="This is custom Docker Image for Dr. Ghassemi's Web Application Course"


RUN apt update
RUN apt-get update -qq


ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get install -y mysql-server 
RUN service mysql start && mysql -e "CREATE USER 'master'@'localhost' IDENTIFIED BY 'master';CREATE DATABASE db; GRANT ALL PRIVILEGES ON db.* TO 'master'@'localhost';"


RUN apt -y install python3-pip
RUN apt -y install vim
RUN mkdir /app
COPY . /app
WORKDIR /app
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt


RUN pip install eventlet gevent-websocket

EXPOSE 8080 
ENV PORT 8080
ENV FLASK_ENV=production
ENV PYTHONUNBUFFERED=1


CMD service mysql start && exec gunicorn --bind :$PORT --workers 1 --worker-class eventlet --threads 8 --timeout 0 --log-level debug app:app
# ----------------------------------------------------- 