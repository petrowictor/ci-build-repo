#!/bin/bash

set -e

APP_REPO=$1
IMAGE_NAME=$2
TAG=$3

echo "Cloning repo..."
git clone $APP_REPO app

cd app

echo "Building jar..."
./gradlew bootJar

echo "Copy jar..."
cp build/libs/*.jar ../app.jar

cd ..

echo "Building docker image..."
docker build -t $IMAGE_NAME:$TAG .

echo "Push image..."
docker push $IMAGE_NAME:$TAG