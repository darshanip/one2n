#!/bin/bash

# Update and install required packages
sudo yum update -y
sudo yum install -y python3 git openssl

# Download the Python app
wget https://gist.githubusercontent.com/darshanip/9129da0a31241cc088a63915a1241a0a/raw/527a51b11afd7a214a3eda48368357f421250b16/app.py -O ~/app.py

# Install Python dependencies (Flask, Boto3)
sudo pip3 install --upgrade pip
sudo pip3 install flask boto3

# Generate SSL certificates for secure connections
openssl genpkey -algorithm RSA -out ~/key.pem
openssl req -new -key ~/key.pem -out ~/csr.pem -subj "/C=US/ST=State/L=City/O=Company/OU=Dev/CN=localhost"
openssl x509 -req -in ~/csr.pem -signkey ~/key.pem -out ~/cert.pem

# Start the app in the background and log output
nohup python3 ~/app.py > ~/app.log 2>&1 &

# Confirmation message
echo "Setup complete. App is running, logs are in ~/app.log"