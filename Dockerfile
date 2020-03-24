FROM ros:kinetic

RUN apt-get update && apt-get install -y \

	#hier alle apt pakete zum installieren rein + \

	ros-kinetic-rosbridge-suite \
	ros-kinetic-naoqi-bridge \
	ros-kinetic-pepper-robot \
	ros-kinetic-web-video-server \
	ros-kinetic-usb-cam \
	ros-kinetic-image-view 


	#ros-kinetic-pepper-meshes	#das installiert evtl. nicht richtig weil einer Nutzereingabe nötig ist -> per hand im image nachinstallieren!
	
	#dann im Dockerfile-Verzeichnis neues image bauen
		#'docker build -t ros:kinetic_custom .'
	#nach dem bauen altes image loeschen mit 
		#'docker rmi $(docker images -f "dangling=true" -q)'
	#evtl. neuer tag des images muss ins bash script!
	


