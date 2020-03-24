FROM ros:kinetic

RUN apt-get update && apt-get install -y \
	#hier alle apt pakete zum installieren rein + \

	ros-kinetic-rosbridge-suite \
	ros-kinetic-naoqi-bridge \
	ros-kinetic-pepper-robot \
	ros-kinetic-web-video-server \
	ros-kinetic-image-view 


	#ros-kinetic-pepper-meshes	#das installiert evtl. nicht richtig weil einer Nutzereingabe nötig ist -> per hand im image nachinstallieren!
	
	#dann im Dockerfile-Verzeichnis 'docker build -t ros:kinetic_custom .' -> neues ros_kinetic_image
	#evtl. neuer tag des images muss ins bash script!
	


