#!/bin/bash
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

echo "Starting user data script"

# Update the package index
echo "Updating package index..."
sudo apt-get update -y

# Install required packages
echo "Installing required packages..."
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Add Docker’s official GPG key
echo "Adding Docker's official GPG key..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Add Docker APT repository
echo "Adding Docker APT repository..."
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Update the package index again
echo "Updating package index again..."
sudo apt-get update -y

# Install Docker
echo "Installing Docker..."
sudo apt-get install -y docker-ce

# Start Docker service
echo "Starting Docker service..."
sudo systemctl start docker

# Enable Docker service to start on boot
echo "Enabling Docker service to start on boot..."
sudo systemctl enable docker

# Add the current user to the Docker group to allow running Docker without sudo
echo "Adding current user to the Docker group..."
sudo usermod -aG docker ${USER}

# Verify Docker installation
echo "Verifying Docker installation..."
docker --version

# Run a test Docker container (optional)
echo "Running a test Docker container..."
sudo docker run hello-world

echo "User data script completed"