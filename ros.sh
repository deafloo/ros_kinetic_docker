#!/bin/bash

imageTag=ros:kinetic_custom	#as described at the build process
imageName=ros_kinetic_docker	#name of the Docker-container

isRunning="$(docker inspect -f '{{.State.Running}}' $imageName)" > /dev/null 2>&1	#suppress console output
imageStatus="$(docker inspect -f '{{.State.Status}}' $imageName)" > /dev/null 2>&1
detectMaster="$(docker inspect -f '{{.State.Running}}' ros_kinetic_master)" > /dev/null 2>&1

if [ $detectMaster ]
then
	read -p "Rosmaster detected. Would you like to connect to ROS-Network (y/n)? " answer
	case ${answer:0:1} in
		y|Y )
			#Start with ROS-Network
			if [ ! $isRunning ]
			then
				echo "Starting new container..."
				echo "Please kill docker container after use"

				sudo docker run \
					-it \
					--name=$imageName \
					--net ros_network \
					--user=$UID \
					--env ROS_HOSTNAME=$imageName \
					--env ROS_MASTER_URI=http://ros_kinetic_master:11311 \
					--env="DISPLAY" \
					--workdir="/home/$USER" \
					--volume="/home/$USER:/home/$USER" \
					--volume="/etc/group:/etc/group:ro" \
					--volume="/etc/passwd:/etc/passwd:ro" \
					--volume="/etc/shadow:/etc/shadow:ro" \
					--volume="/etc/sudoers.d:/etc/sudoers.d:ro" \
					--volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
					$imageTag

					#for webcam support add --device="/dev/video0:/dev/video0:rwm" \
			fi
		;;
		* )
			#Start Container without ROS-Network
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
					$imageTag \
					roscore

					#for webcam support add --device="/dev/video0:/dev/video0:rwm" \

				echo "Starting interactive terminal..."

				sudo docker exec \
					-it \
					$imageName \
					bash
			fi
		;;
		esac

	if [ "$imageStatus" == "exited" ]
	then
		sudo docker start \
			$imageName
	else
		sudo docker exec \
			-it \
			$imageName \
			bash
	fi

else #if Master is not detected -> just launch container as usual
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
					$imageTag \
					roscore

					#for webcam support add --device="/dev/video0:/dev/video0:rwm" \

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
fi
