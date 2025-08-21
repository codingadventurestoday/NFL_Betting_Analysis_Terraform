# Pull Docker images (adjust these commands for your project)
sudo docker pull mysql:9.4
sudo docker pull python:3.11-slim
sudo docker pull rabbitmq:4.1.3

sudo docker run -d --name mysql-db \
  -v "$MOUNT_POINT"/mysql-data:/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD=your_secure_password \
  mysql:8.0

echo "Successfully running MySQL image"

sudo docker run -d --name python-app \
  -v "$MOUNT_POINT"/app-code:/app \
  python:3.11-slim python3 /app/your_script.py

echo "Successfully running python image"

sudo docker run -d --name rabbitmq-server \
  -p 5672:5672 -p 15672:15672 \
  -v "$MOUNT_POINT"/rabbitmq-data:/var/lib/rabbitmq \
  rabbitmq:4.1.3

echo "Successfully running RabbitMQ image"
