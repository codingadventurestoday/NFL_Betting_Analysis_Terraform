#!/bin/bash

# Pull Docker images
sudo docker pull mysql:9.4
sudo docker pull python:3.11-slim
sudo docker pull rabbitmq:4.1.3
sudo docker pull:nginx:1.29.1

sudo mkdir -p "$MOUNT_POINT"/mysql-data
sudo mkdir -p "$MOUNT_POINT"/app-code
sudo mkdir -p "$MOUNT_POINT"/rabbitmq-data
sudo mkdir -p "$MOUNT_POINT"/nginx-data

if [ ! -d "$MOUNT_POINT"/app-code/.git ]; then
    echo "Cloning Git repository..."
    sudo git clone https://github.com/codingadventurestoday/NFL_Betting_Analysis.git "$MOUNT_POINT"/app-code
else
    echo "Git repository already exists. Skipping clone."
fi

if ! sudo docker network inspect my-container-network &> /dev/null; then
    echo "Creating Docker network..."
    sudo docker network create my-container-network
else
    echo "Docker network already exists. Skipping creation."
fi

if ! sudo docker ps -a --format '{{.Names}}' | grep -q "mysql-db"; then
    echo "Starting MySQL container..."
    sudo docker run -d --name mysql-db \
        --network my-container-network \
        -v "$MOUNT_POINT"/mysql-data:/var/lib/mysql \
        -e MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD} \ 
        mysql:9.4
        echo "Successfully running MySQL image"
else
    echo "MySQL container already exists. Skipping run."
fi

if ! sudo docker ps -a --format '{{.Names}}' | grep -q "python-app"; then
    echo "Starting Python container..."
    sudo docker run -d --name python-app \
        --network my-container-network \
        -v "$MOUNT_POINT"/app-code:/app \
        python:3.11-slim tail -f /dev/null
else
    echo "Python container already exists. Skipping run."
fi

if ! sudo docker ps -a --format '{{.Names}}' | grep -q "rabbitmq-server"; then
    echo "Starting RabbitMQ container..."
    sudo docker run -d --name rabbitmq-server \
        --network my-container-network \
        -p 5672:5672 \
        -p 15672:15672 \
        -p 15671:15671 \
        -v "$MOUNT_POINT"/rabbitmq-data:/var/lib/rabbitmq \
        rabbitmq:4.1.3
else
    echo "RabbitMQ container already exists. Skipping run."
fi

if ! sudo docker ps -a --format '{{.Names}}' | grep -q "nginx_static"; then
    echo "Starting Nginx container..."
    sudo docker run -d --name nginx_static \
        --network my-container-network \
        -v "$MOUNT_POINT"/nginx_static:/usr/share/nginx/html \
        -v "$MOUNT_POINT"/nginx-conf:/etc/nginx/conf.d \
        -p 80:80 \
        nginx:1.29.1
else
    echo "Nginx container already exists. Skipping run."
fi