#!/bin/bash

imageTag=ros:kinetic_custom	#as described at the build process
imageName=ros_kinetic_docker	#name of the Docker-container

isRunning="$(docker inspect -f '{{.State.Running}}' $imageName)" > /dev/null 2>&1	#suppress console output
imageStatus="$(docker inspect -f '{{.State.Status}}' $imageName)" > /dev/null 2>&1

if [ ! $isRunning ]
then
	echo "Starting new container with roscore in background"
	echo "Please kill docker container after use"

	sudo docker run \
		-d \
		--name=$imageName \
		--user=$UID \
		--env="DISPLAY" \
		--workdir="/home/$USER" \
		--volume="/home/$USER:/home/$USER" \
		--volume="/etc/group:/etc/group:ro" \
		--volume="/etc/passwd:/etc/passwd:ro" \
		--volume="/etc/shadow:/etc/shadow:ro" \
		--volume="/etc/sudoers.d:/etc/sudoers.d:ro" \
		--volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
		--volume="/dev/video0:/dev/video0:ro" \
		$imageTag \
		roscore

	echo "Starting interactive terminal..."

	sudo docker exec \
		-it \
		$imageName \
		bash
	
elif [ "$imageStatus" == "exited" ]
then
	sudo docker start \
		$imageName
else
	sudo docker exec \
		-it \
		$imageName \
		bash
fi
