#!/bin/bash
sudo apt update -y

sudo apt install -y nginx

echo "<h1>welcome to $(hostname) server</h1>" | sudo tee /var/www/html/index.html
