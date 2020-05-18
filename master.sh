#!/bin/bash

imageTag=ros:kinetic_custom	#as described at the build process
imageName=ros_kinetic_master	#name of the Docker-container

echo "Starting new container with roscore in background"
echo "create internal network:" `exec docker network create ros_network`
echo "Please kill docker container after use"

sudo docker run \
	-it \
	--rm \
	--name=$imageName \
	--net ros_network \
	$imageTag \
	roscore
