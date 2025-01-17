#!/bin/bash 

# URL of the repository to clone
REPO_URL="https://github.com/Nassibi107/templite-css-html-3.git"

# Directory where the repository will be cloned
DEST_DIR="/home/app/webTemplate"

# Clone the repository using git
echo "Cloning repository..."
git clone $REPO_URL /home/app/webTemplate

echo "Repository cloned to $DEST_DIR."
