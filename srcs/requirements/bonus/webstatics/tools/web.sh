#!/bin/bash 

REPO_URL="https://github.com/Nassibi107/templite-css-html-3.git"


DEST_DIR="/home/app/webTemplate"


echo "Cloning repository..."
git clone $REPO_URL /home/app/webTemplate

echo "Repository cloned to $DEST_DIR."
