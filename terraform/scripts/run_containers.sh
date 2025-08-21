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

sudo docker network create my-container-network

sudo docker run -d --name mysql-db \
  --network my-container-network \
  -v "$MOUNT_POINT"/mysql-data:/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD=your_secure_password \
  mysql:9.4

echo "Successfully running MySQL image"

sudo docker run -d --name python-app \
  --network my-container-network \
  -v "$MOUNT_POINT"/app-code:/app \
  python:3.11-slim tail -f /dev/null

echo "Successfully running python image"

sudo docker run -d --name rabbitmq-server \
  --network my-container-network \
  -p 5672:5672 \
  -p 15672:15672 \
  -p 15671:15671 \
  -v "$MOUNT_POINT"/rabbitmq-data:/var/lib/rabbitmq \
  rabbitmq:4.1.3

echo "Successfully running RabbitMQ image"

sudo docker run -d --name nginx_static \
  --network my-container-network \
  -v "$MOUNT_POINT"/nginx_static:/usr/share/nginx/html \
  -v "$MOUNT_POINT"/nginx-conf:/etc/nginx/conf.d \
  -p 80:80 \
  nginx:1.29.1

echo "Successfully running nginx image"