#!/bin/bash
sudo apt update -y
sudo apt install nginx -y
echo "<p> Smoothie Power! </p>" > /var/www/html/index.html